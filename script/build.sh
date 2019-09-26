# /bin/bash

cd /opt/devops-demo

tar -cf demo.tar.gz bin conf lib 

docker rmi -f devops-demo:1.0

echo "Start building..."
docker build -t devops-demo:1.0 /opt/devops-demo

echo "Checking..."
docker images | grep devops-demo

echo "Running..."
docker run -d -p 18888:18888 devops-demo:1.0
