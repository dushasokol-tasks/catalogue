#!/usr/bin/env bash

ls -al
cat > ../deploy.yml <<-EOF
source stage.yml
EOF
