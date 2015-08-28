#!/usr/bin/env python
#Written by Alvaro Castellano - alvaro.castellano.vela@gmail.com on 08/28/2015
import sys
import ast

data_string = ''

for line in sys.stdin:
    data_string += line

data_dict = ast.literal_eval(data_string)

for server in data_dict['droplets']:
	print "["+server['name']+"]"
	print server['ip_address']
	print
