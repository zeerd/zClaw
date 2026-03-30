#!/bin/bash

install -d $HOME/.comfyui/{input,output,models,user,custom_nodes}
docker compose up -d
