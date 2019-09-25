# /bin/bash

docker rmi -f devops-demo

echo "Start building..."
docker build -t devops-demo:1.0 .

echo "Checking..."
docker images | grep devops-demo

echo "Running..."
docker run -d devops-demo