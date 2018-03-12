# OpenShift Example

* `demo-auth.sh` - script that will generate an example KDC server, client application and demonstrate authentication
* `krb5-build.yaml` - build configuration to build kinit-sidecar and kdc-server containers
* `krb5-server-deploy.yaml` - example KDC server deployment template. 
* `example-client-deploy.yaml` - example kinit-sidecar deployment template

The easiest way to use these resources is as follows:

```
# git clone https://github.com/edseymour/kinit-sidecar.git
# cd openshift
# ./demo-auth.sh
```

The demo-auth.sh script creates a new demo project (krb-ex-nnnn) into which it deploys an example KDC server and an example KRB5 client application. 

Once the applications have been deployed, the script automates the kinit-sidecar container to create a new example principal in the KDC server, and obtain its keytab. Once this is complete, the logs for the example application are shown. 

The example app runs `klist` every few seconds, once a valid token is obtained, this will be displayed. The kinit-sidecar runs `kinit` every 10 seconds, so it will generally take up to 10 seconds before a valid token is shown in the example app's logs. 
