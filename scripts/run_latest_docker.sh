#!/usr/bin/env bash

docker run -it -p 3000:3000 -e SECRET_KEY_BASE="your_master-key_content" soladi/soladi:latest
