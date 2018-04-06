#!/bin/bash

sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
