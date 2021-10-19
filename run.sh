#!/bin/bash
set -o errexit

echo "### Building stack on focal"
docker build stacks/focal --target build --tag localhost:5000/nicholasdille/cnb-stack-build:focal --push
docker build stacks/focal --target run   --tag localhost:5000/nicholasdille/cnb-stack-run:focal --push

echo "### Building stack on groovy"
docker build stacks/groovy --target build --tag localhost:5000/nicholasdille/cnb-stack-build:groovy --push
docker build stacks/groovy --target run   --tag localhost:5000/nicholasdille/cnb-stack-run:groovy --push

echo "### Building basic builder"
pack builder create localhost:5000/nicholasdille/cnb-builder-basic:focal --config builder/basic/builder.toml --publish
pack config default-builder localhost:5000/nicholasdille/cnb-builder-basic:focal

echo "### Building buildpacks and builder"
pack buildpack package localhost:5000/nicholasdille/cnb-buildpack-kubectl --config packages/kubectl/package.toml --publish
pack buildpack package localhost:5000/nicholasdille/cnb-buildpack-helm --config packages/helm/package.toml --publish
pack builder create localhost:5000/nicholasdille/cnb-builder-tools:focal --config builder/tools/builder.toml --publish

echo "### Building app"
pack build localhost:5000/nicholasdille/cnb-test --builder localhost:5000/nicholasdille/cnb-builder-tools:focal --path app/test

echo "### Rebase app"
pack rebase localhost:5000/nicholasdille/cnb-test