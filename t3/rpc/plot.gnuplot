#!/usr/bin/env gnuplot
set datafile separator ","
set term png
set output 'plot.png'
plot "< awk -F ',' '{if($1 == \"add\") print}' 'results-corei5.csv'" every ::1 u 3:2 t "add" with linespoints ls 1,\
     "< awk -F ',' '{if($1 == \"sub\") print}' 'results-corei5.csv'" every ::1 u 3:2 t "sub" with linespoints ls 2,\
     "< awk -F ',' '{if($1 == \"mul\") print}' 'results-corei5.csv'" every ::1 u 3:2 t "mul" with linespoints ls 3,\
     "< awk -F ',' '{if($1 == \"div\") print}' 'results-corei5.csv'" every ::1 u 3:2 t "div" with linespoints ls 4
