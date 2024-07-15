# Build

``` 
bash gradlew build
```

# Run

## via gradle

Add the port

``` 
tasks.bootRun {
	systemProperties["server.port"] = "7080"
}
``` 
and then run

``` 
bash gradlew bootRun
```

## via Applicaiton in Idea

First right click on the Application and select "Run > Appname"

In Run > Edit Configurations > Application
add

``` 
--server.port=7080
```

# Interact

Unauthenticated access is allowed for "/public/*"

```
curl http://localhost:7080/public/hello
```


# Docker

## Build manually without gradle
```
docker build --build-arg JAR_FILE=build/libs/\*.jar -t ghcr.io/alfrepo/demo-consume-api  -f src/main/docker/Dockerfile  .
```


## Build with Gradle

You can build a tagged docker image with Gradle in one command:

<https://spring.io/guides/gs/spring-boot-docker#_build_a_docker_image_with_gradle>


Use GitHub packages
 - <https://medium.com/devopsturkiye/pushing-docker-images-to-githubs-registry-manual-and-automated-methods-19cce3544eb1>
 - <https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry>
and use personal token like "azure_service_bus_k8s" on the path. 


./gradlew bootBuildImage --imageName=ghcr.io/alfrepo/demo-consume-api


```
sudo su
./gradlew bootBuildImage --imageName=ghcr.io/alfrepo/demo-consume-api
```

## And run



```
sudo docker run -p 8080:8080 ghcr.io/alfrepo/demo-consume-api
```

Set the profile via
SPRING_PROFILES_ACTIVE=dev
SPRING_PROFILES_ACTIVE=prod

```
sudo docker run -e "SPRING_PROFILES_ACTIVE=dev" -p 8080:8080 ghcr.io/alfrepo/demo-consume-api
```


# Kubernetes K8s


## Minkube


```
minikube start
```

## Deploymnent requires a docker registry

### Set up GitHub docker registry

https://medium.com/devopsturkiye/pushing-docker-images-to-githubs-registry-manual-and-automated-methods-19cce3544eb1

personal access token name: azure_service_bus_k8s
your_personal_access_token : see keepass

```
docker login --username <your_personal_access_token_name> --password <your_personal_access_token> ghcr.io

docker login --username azure_service_bus_k8s --password <ghp_..........S> ghcr.io

```

### now push  to the docker registry

```
docker push 'ghcr.io/alfrepo/demo-consume-api'
```

Then find your docker repo under
```
ghcr.io/alfrepo/demo-consume-api
```

And make it "public" under "Change package visibility" 
so that minikube can access it.

## Deploymnent on K8s manually

Deploy my prebuilt container

```
kubectl create deployment demo-consume-api --image=ghcr.io/alfrepo/demo-consume-api:latest
```

Now expose the api
```
kubectl expose deployment demo-consume-api --type=LoadBalancer --port=8080
```

