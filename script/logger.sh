( # In a subshell, for isolation, protecting $!
  while true; do
    echo "Timestamp: $(date)" >> /var/log/nginx-container/resource.log &
    curl -I localhost:80 >> /var/log/nginx-container/resource.log &
    docker ps --filter "name=nginx-server" >> /var/log/nginx-container/resource.log &
    docker stats nginx-server --no-stream >> /var/log/nginx-container/resource.log &
    sleep 10;
  done
)