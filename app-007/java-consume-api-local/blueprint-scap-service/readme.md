
# local


## Build 
``` shell
mvn clean install -Penable-dev-docker-builds -Penable-docker-builds
```

## Run

You can pick on which port to run the app via ``-Dserver.port=8080``

You can pick the log level `` -Dlogging.level.root=DEBUG``

``` shell
mvn spring-boot:run  -Dserver.port=8080  -Dlogging.level.root=DEBUG
```

# Use

The app is then reachable under <http://localhost:8080/api/v1/user/todos>
