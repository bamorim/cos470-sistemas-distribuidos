#include "VectorMath.h"
class VectorMathHandler : virtual public VectorMathIf {
 public:
  VectorMathHandler() {
    // Your initialization goes here
  }

  void add(std::vector<int32_t> & _return, const std::vector<int32_t> & vec, const int32_t num) {
    _return.reserve(vec.size());
    for(auto n : vec) {
      _return.push_back(n+num);
    }
  }

  void sub(std::vector<int32_t> & _return, const std::vector<int32_t> & vec, const int32_t num) {
    _return.reserve(vec.size());
    add(_return, vec, num * -1);
  }

  void mul(std::vector<int32_t> & _return, const std::vector<int32_t> & vec, const int32_t num) {
    _return.reserve(vec.size());
    for(auto n : vec) {
      _return.push_back(n*num);
    }
  }

  void div(std::vector<int32_t> & _return, const std::vector<int32_t> & vec, const int32_t num) {
    if(num == 0){
      ArithmeticException exception;
      exception.message = "Cannot divide by zero.";
      throw exception;
    }

    _return.reserve(vec.size());
    for(auto n : vec){
      _return.push_back(n/num);
    }
  }

};
