#!/bin/bash
# Define image name, version and registries
image="xmrig"
version="6.22.2"
registries=("docker.io" "ghcr.io" "quay.io")

# Build the image
docker build . --build-arg VERSION_TAG=$version --tag ${registries[0]}/cniweb/$image:$version

# Check if the command was successful
if [ $? -ne 0 ]; then
  echo "Docker build failed!"
  exit 1
fi

echo "Docker build succeeded!"

# Check if we should only build (for CI/CD usage)
if [ "$1" = "build-only" ]; then
  echo "Build-only mode: skipping push to registries"
  exit 0
fi

# Tag and push the images
for registry in "${registries[@]}"; do
  docker tag ${registries[0]}/cniweb/$image:$version $registry/cniweb/$image:$version
  docker tag ${registries[0]}/cniweb/$image:$version $registry/cniweb/$image:latest
  
  # Push both versioned and latest tags
  docker push $registry/cniweb/$image:$version
  docker push $registry/cniweb/$image:latest
done
