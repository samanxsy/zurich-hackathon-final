#!/bin/bash

# GET THE PUBLIC IP
public_ip=$(curl -s http://checkip.amazonaws.com)
sleep 1

ip_cidr="$public_ip/32"

# Format the output as JSON
echo "{\"my_public_ip\": \"$ip_cidr\"}"