#!/bin/bash

cd dvna && git pull origin master
export MYSQL_USER=root
export MYSQL_DATABASE=dvna
export MYSQL_PASSWORD=<db password>
export MYSQL_HOST=127.0.0.1
export MYSQL_PORT=3306
pm2 start server.js
