( # In a subshell, for isolation, protecting $!
  while true; do
    curl -I localhost:80 >> log &
    docker ps --filter "name=nginx-server" >> log &
    docker stats nginx-server --no-stream >> log &
    sleep 10;
  done
)