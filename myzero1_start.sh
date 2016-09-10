#!/bin/bash
# myzero1 added 
service mysql start
sleep 10s
/usr/sbin/php5-fpm  &
sleep 10s
service nginx start &
