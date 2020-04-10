touch ../deploy.yml
ls -al
cat > ../deploy.yml <<-EOF
source stage.yml
EOF
