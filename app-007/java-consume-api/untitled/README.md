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