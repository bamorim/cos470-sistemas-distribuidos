GEN_DIR:=gen-cpp
GEN_INC:=-I$(GEN_DIR)
GEN_SRC:=$(shell find $(GEN_DIR) -type f -name "*.cpp" ! -name "*skeleton*")
GEN_O:=$(GEN_SRC:.cpp=.o)
CPP_FLAGS:=-Wall -O2 -std=c++11
SOURCES:=$(shell find src -type f -name "*.bin.cpp")
EXECS:=$(patsubst src/%,bin/%,$(SOURCES:.bin.cpp=))

all: $(EXECS)

$(GEN_DIR)/%.o: $(GEN_DIR)/%.cpp
	g++ $(CPP_FLAGS) -c -o $@ $<

bin/%: src/%.bin.cpp $(GEN_SRC)
	g++ $(CPP_FLAGS) -o $@ $(GEN_INC) $^ -lthrift

$(GEN_DIR)/%.cpp: vector_math.thrift
	thrift --gen cpp vector_math.thrift

.PHONY:clean
clean:
	@rm $(GEN_DIR)/*.o
	@rm bin/*
