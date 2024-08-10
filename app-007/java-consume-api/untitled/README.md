# Build

``` 
./gradlew clean build

#if you wanna skip tests
./gradlew clean build -x test
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

## login

Use the login / pass 
from ''applicaiton.properties''

should be admin/admin


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
./gradlew bootBuildImage --imageName=ghcr.io/alfrepo/demo-consume-api -PimageTag=latest```
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
docker push 'ghcr.io/alfrepo/demo-consume-api:latest'
```

Then find your docker repo under
```
ghcr.io/alfrepo/demo-consume-api
```

And make it "public" under "Change package visibility" 
so that minikube can access it.

And you can pull your image via 

```
docker pull ghcr.io/alfrepo/demo-consume-api:latest
```

## Using kubectl with minikube

Deploy my prebuilt container from the docker-registry.

Important: Use the `minikube kubectl` to avoid the "Unauthorized" error.


Or just start using the alias
```
function kubectl {
param(
[Parameter(Mandatory = $false)]
[string] $arguments
)
minikube kubectl -- $arguments
}
```

## Expose the port on windows

```
minikube service --url demo-consume-api
http://127.0.0.1:52260
❗  Because you are using a Docker driver on windows, the terminal needs to be open to run it.```
```

## Deploymnent on K8s manually

```
minikube kubectl -- create deployment demo-consume-api --image=ghcr.io/alfrepo/demo-consume-api:latest
minikube kubectl -- delete deployment demo-consume-api
```

And go to

```
http://127.0.0.1:52260/public/hello/
```


# Generating WSDL code
as in 
- https://www.baeldung.com/java-gradle-create-wsdl-stubs
- https://github.com/bjornvester/wsdl2java-gradle-plugin

Generates code from ``src/main/resources/wsdl/*.wsdl``

generated classes are saved in the ``build/generated/sources/wsdl2java`` folder

```
bash gradlew clean wsdl2java
```



# Creating a SOAP api

TODO: turn into Terraform code

- go to Azure API Management Service
- Add API
- choose WSDL
- choose SOAP pass-through
- API URL suffix like "suffix1"  
- select new API "PutMessage", Settings, Products, choose a published  product like "My ProductSoap"



