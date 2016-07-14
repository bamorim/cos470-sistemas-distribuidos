#include <iostream>
#include <vector>
#include "VectorMath.h"

#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>

using namespace apache::thrift;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;

void print_all(const std::vector<int32_t> xs){
  for (auto x : xs){
    std::cout << x << " ";
  }
  std::cout << std::endl;
}

int main(){
  boost::shared_ptr<TTransport> socket(new TSocket("localhost", 9090));
  boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
  boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
  VectorMathClient client(protocol);

  try{
    transport->open();
    std::vector<int32_t> numbers;
    for(int32_t i = 0; i < 10; i++){
      numbers.push_back(i);
    }
    print_all(numbers);

    client.add(numbers, numbers, 10);
    print_all(numbers);

    client.sub(numbers, numbers, 5);
    print_all(numbers);

    client.mul(numbers, numbers, 4);
    print_all(numbers);

    client.div(numbers, numbers, 2);
    print_all(numbers);

    client.div(numbers, numbers, 0);
  } catch (ArithmeticException e) {
    std::cout << "Exception ocurred: " << e.message << std::endl;
  }
}
