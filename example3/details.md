In this manifest, we are defining nginx as the docker image name to run, but we never tell Kubernetes where it should look for this image.

The same way we can store code repositories in services like Github or Gitlab, we can store images in a docker registry. When we don’t specify which registry we want to use, Kubernetes will assume we mean DockerHub.

