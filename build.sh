#!/bin/bash
repo="${BUILD_REPO}"
tag="${BUILD_TAG}"

if [ -z "${repo}" ]
then
    repo="registry.aunablockchain.com/auna"
fi
if [ -z "${tag}" ]
then
    tag="latest"
fi

echo "Building image"
docker build -t $repo/auna-docs:$tag --compress .

echo ""
echo "Pushing image"
docker push $repo/auna-docs:$tag
