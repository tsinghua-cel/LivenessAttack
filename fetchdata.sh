#!/bin/bash
rm -rf data && mkdir data && cp -r /var/lib/docker/volumes/liveness_* data/
