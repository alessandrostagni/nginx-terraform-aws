# Check health status of containers and resource usage
USER_FOLDER=/home/ec2-user
while true; do
  echo "Timestamp: $(date)" >> $USER_FOLDER/nginx-container/resource.log # Using a separate Timestamp from curl, in case curl call fails.
  curl -I localhost:80 >> $USER_FOLDER/nginx-container/resource.log
  docker ps --filter "name=nginx-server" >> $USER_FOLDER/nginx-container/resource.log
  docker stats nginx-server --no-stream >> $USER_FOLDER/nginx-container/resource.log
  echo '---' >> $USER_FOLDER/nginx-container/resource.log
  sleep 10;
done