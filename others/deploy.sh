#!/bin/bash
# Docsify 博客本地一键部署脚本，运行此脚本可以在本地预览网站
# Win下请使用Git Bash执行此脚本
echo "全局安装docsify..."
npm i docsify-cli -g

echo "打开浏览器..."
start http://localhost:3000

echo "启动docsify服务..."
docsify serve docs

