
Run Kaniko against local workspace

``docker run --rm -v `pwd`:/workspace gcr.io/kaniko-project/executor:v1.6.0-debug --no-push -v debug``



# Resources

https://github.com/GoogleContainerTools/kaniko

https://blog.csanchez.org/2020/09/15/building-docker-images-with-kaniko-pushing-to-docker-registries/