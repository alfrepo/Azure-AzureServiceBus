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
docker build --build-arg JAR_FILE=build/libs/\*.jar -t springio/demo-consume-api -f src/main/docker/Dockerfile  .
```


## Build with Gradle

You can build a tagged docker image with Gradle in one command:

<https://spring.io/guides/gs/spring-boot-docker#_build_a_docker_image_with_gradle>

```
sudo su
./gradlew bootBuildImage --imageName=springio/demo-consume-api --imageTag snapshot
```

## And run



```
sudo docker run -p 8080:8080 springio/demo-consume-api
```

Set the profile via
SPRING_PROFILES_ACTIVE=dev
SPRING_PROFILES_ACTIVE=prod

```
sudo docker run -e "SPRING_PROFILES_ACTIVE=dev" -p 8080:8080 springio/demo-consume-api
```
