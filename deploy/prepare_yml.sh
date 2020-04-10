#!/usr/bin/env bash

ls -al

cat > deploy.yml <<-EOF
source deploy/stage.yml
EOF
