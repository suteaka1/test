#!/bin/sh

#pinglog.txt is https://gist.github.com/suteaka1/1440b2a2f354fac21654
echo $(grep "statistics" pinglog.txt) \n echo $(grep "% packet loss" pinglog.txt)
