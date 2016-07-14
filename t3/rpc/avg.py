#!/usr/bin/env python
import sys
x = [float(line) for line in sys.stdin.readlines()]
print(sum(x)/len(x))
