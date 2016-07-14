#!/usr/bin/env gnuplot
set datafile separator ","
set term png
set output 'plot.png'
plot "< awk -F ',' '{if($2 == \"1000\") print}' 'results.csv'" every ::1 u 1:3 t "sequential-arrival" with linespoints ls 1,\
     "< awk -F ',' '{if($2 == \"0\") print}' 'results.csv'" every ::1 u 1:3 t "bulk-arrival" with linespoints ls 2
