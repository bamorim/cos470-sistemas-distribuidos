#include<iostream>
#include<vector>
#include<random>
#include<algorithm>
#include<thread>
#include<sys/time.h>

#include "VectorMath.h"

#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>

#include <boost/make_shared.hpp>

#define MAX_NUMBER 10000

using namespace apache::thrift::transport;
using namespace apache::thrift::protocol;

#ifdef DEBUG
void print_all(const std::vector<int32_t> xs){
  for (auto x : xs){
    std::cout << x << " ";
  }
  std::cout << std::endl;
}
#endif

std::vector<int32_t> generate(int n){
  std::vector<int32_t> numbers;
  numbers.reserve(n);
  std::cout << "Reserved " << n*4 << " bytes" << std::endl;

  std::uniform_int_distribution<int32_t> dist(0, MAX_NUMBER);
  std::mt19937 mt;
  auto generator = std::bind(dist, mt);

  std::generate_n(std::back_inserter(numbers), n, generator);
  std::cout << "Generated " << n << " random numbers" << std::endl;

  return numbers;
}

int main(int argc, char** argv){
  if(argc < 5) {
    std::cout << "Usage: " << argv[0] << " <N> <K> <operation> <operand> <host=localhost> <port=9090>" << std::endl;
    std::cout << "N: number of numbers :D" << std::endl;
    std::cout << "K: number of threads" << std::endl;
    std::cout << "operation: (a|s|m|d)" << std::endl;
    std::cout << "operand: Right-hand side operand" << std::endl;
    exit(1);
  }

  auto N = atoi(argv[1]);
  auto K = atoi(argv[2]);
  auto step = N/K;
  auto operation = argv[3][0];
  auto operand = atoi(argv[4]);
  auto numbers = generate(N);
  auto host = argc > 5 ? argv[5] : "localhost";
  auto port = argc > 6 ? atoi(argv[6]) : 9090;

  #ifdef DEBUG
  print_all(numbers);
  #endif

  struct timeval start_time, end_time;
  gettimeofday(&start_time, NULL);

  std::vector<std::thread> threads;
  for(auto i = 0; i < K; i++){
    auto start = numbers.begin() + i*step;
    threads.push_back(std::thread([start, step, operation, operand, host, port](){
      auto socket = boost::make_shared<TSocket>(host, port);
      auto transport = boost::make_shared<TBufferedTransport>(socket);
      auto protocol = boost::make_shared<TBinaryProtocol>(transport);

      VectorMathClient client(protocol);
      transport->open();

      std::vector<int32_t> sub(start, start+step);
      switch(operation){
      case 'a':
        client.add(sub, sub, operand);
        break;
      case 'm':
        client.mul(sub, sub, operand);
        break;
      case 's':
        client.sub(sub, sub, operand);
        break;
      case 'd':
        client.div(sub, sub, operand);
      }
      std::copy(sub.begin(), sub.end(), start);
    }));
  }

  std::cout << "Sent " << K << " jobs" << std::endl;

  for(auto &t : threads) t.join();

  gettimeofday(&end_time, NULL);
  double seconds = ((end_time.tv_sec  - start_time.tv_sec) * 1000000u + 
                    end_time.tv_usec - start_time.tv_usec) / 1.e6;
  std::cout << "Ran in " << seconds << " seconds" << std::endl;

  #ifdef DEBUG
  print_all(numbers);
  #endif
}
