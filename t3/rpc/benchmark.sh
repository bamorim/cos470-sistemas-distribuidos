#!/bin/bash
N=100000000
TIMES=5

function bench_add {
  for i in {1..$TIMES}; do
    ./bin/ex_client $N $1 a 10
  done
}

function bench_sub {
  for i in {1..$TIMES}; do
    ./bin/ex_client $N $1 s 10
  done
}

function bench_mul {
  for i in {1..$TIMES}; do
    ./bin/ex_client $N $1 m 4
  done
}

function bench_div {
  for i in {1..$TIMES}; do
    ./bin/ex_client $N $1 d 2
  done
}

function bench_all {
  echo "add,$(bench_add $1 | ./avg.py),$1"
  echo "sub,$(bench_sub $1 | ./avg.py),$1"
  echo "mul,$(bench_mul $1 | ./avg.py),$1"
  echo "div,$(bench_div $1 | ./avg.py),$1"
}

echo "operation,mean,k"
for k in 1 2 4 8 16 32 64 128; do
  bench_all $k
done
