#!/bin/bash
apt update -y && apt install nodejs npm -y
npm install -g yarn
cd /home/ubuntu && git clone https://github.com/sweetiu172/Blog-React-CRUD-MYSQL.git
cd /home/ubuntu/Blog-React-CRUD-MYSQL/frontend
yarn && yarn start

