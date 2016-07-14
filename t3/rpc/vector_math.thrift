exception ArithmeticException {
  1: string message;
}

service VectorMath {
  list<i32> add(1:list<i32> vec, 2:i32 num);
  list<i32> sub(1:list<i32> vec, 2:i32 num);
  list<i32> mul(1:list<i32> vec, 2:i32 num);
  list<i32> div(1:list<i32> vec, 2:i32 num) throws (1: ArithmeticException divideByZero);
}
