
# setup environment

## install YJ

Download "https://github.com/sclevine/yj"
and put it on the path, as DIPWSCTRL needs that.


## set up K8s config file

You need KubeConfig file
DIPWSCTRL to know the cluster.

Download the KubeConfig from Rancher (Download Button in NameSpace )


Store and rename it under 
``` shell
"C:\Users\sc******AS\.kube\config"
```


# login to Artifactory

Must be logged in with SC*** user,
to be able to build docke images during mvn build.

``` shell
dipwsctrl docker login
```

# Build
``` shell
mvn clean install -Penable-dev-docker-builds -Penable-docker-builds
```

# Deploy to K8s (namespace of Rancher)

``` shell
namespace=blueprint-scap-service
env=dev-aks-chn
dipwsctrl helm chart deploy -s blueprint-scap-service -n "$namespace" -e $env -c
```

