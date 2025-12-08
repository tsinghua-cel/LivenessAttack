#!/bin/bash
./stop.sh
docker volume ls -q | grep '^liveness_' | xargs docker volume rm
