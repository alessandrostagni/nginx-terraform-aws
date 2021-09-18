( # In a subshell, for isolation, protecting $!
  while true; do
    curl -I localhost:80 >> /var/log/nginx-container/resource.log &
    docker ps --filter "name=nginx-server" >> /var/log/nginx-container/resource.log &
    docker stats nginx-server --no-stream >> /var/log/nginx-container/resource.log &
    sleep 10;
  done
)