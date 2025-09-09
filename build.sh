#!/bin/bash
# Secure build script for XMRig Docker image
# Define image name, version and registries
image="xmrig"
version="6.24.0"
registries=("docker.io" "ghcr.io" "quay.io")

# Support for different Dockerfile variants
DOCKERFILE="${DOCKERFILE:-Dockerfile}"
BUILD_TARGET="${BUILD_TARGET:-production}"

echo "Building XMRig Docker image..."
echo "Version: $version"
echo "Dockerfile: $DOCKERFILE"
echo "Target: $BUILD_TARGET"
echo

# Build the image with security improvements
docker build . \
    --file "$DOCKERFILE" \
    --build-arg VERSION_TAG="$version" \
    --tag "${registries[0]}/cniweb/$image:$version" \
    --tag "${registries[0]}/cniweb/$image:latest"

# Check if the command was successful
if [ $? -ne 0 ]; then
  echo "Docker build failed!"
  exit 1
fi

echo "Docker build succeeded!"

# Run security check if available
if [ -f "security-check.sh" ]; then
    echo "Running security check..."
    ./security-check.sh
fi

# Check if we should only build (for CI/CD usage)
if [ "$1" = "build-only" ]; then
  echo "Build-only mode: skipping push to registries"
  exit 0
fi

# Tag and push the images
for registry in "${registries[@]}"; do
  echo "Tagging and pushing to $registry..."
  docker tag "${registries[0]}/cniweb/$image:$version" "$registry/cniweb/$image:$version"
  docker tag "${registries[0]}/cniweb/$image:$version" "$registry/cniweb/$image:latest"
  
  # Push both versioned and latest tags
  docker push "$registry/cniweb/$image:$version"
  docker push "$registry/cniweb/$image:latest"
done

echo "All builds and pushes completed successfully!"
