#!/bin/bash
docker image rm registry.bcs.cl/auna/auna-docs:nginx
docker build --no-cache -t registry.bcs.cl/auna/auna-docs:latest .
docker push registry.bcs.cl/auna/auna-docs:latest