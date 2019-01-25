#!/bin/bash 


function find_pod()
{
  labelled=$1
  proj=$2

  echo $(oc get pods -n $proj -l $labelled -o name --no-headers | head -n 1)

}

function pod_ready()
{
  pod=$1
  proj=$2

  statusline=$(oc get $pod -n $proj --no-headers)

  ready=$(echo $statusline | awk '{print $2}')

  echo "${ready%%/*}"
}

function watch_deploy()
{
  dc=$1
  proj=$2

  counter=0
  pod=$(find_pod deploymentconfig=$dc $proj)
  while [[ "$pod" == "" ]]
  do
    echo "*** Looking for a pod for $dc in $proj"
    sleep 2

    counter=$((counter + 1))
    [[ $counter -gt 15 ]] && echo "*** Gave up looking for pod $pod for $dc in project $proj after 30 seconds" && break

    pod=$(find_pod deploymentconfig=$dc $proj)
  done

  counter=0
  while [ $(pod_ready $pod $proj) -lt 1 ]
  do
    echo "*** Waiting for $pod in $proj to be ready"
    sleep 5
    counter=$((counter + 1))
    [[ $counter -gt 20 ]] && echo "*** Gave up waiting for pod $pod in project $proj after 400 seconds" && break
  done

}

rand_name=$(head /dev/urandom | base64 | tr -dc a-z0-9 | head -c 4 ; echo '')

project_name=krb-ex-$rand_name

oc new-project $project_name

oc new-app -f krb5-server-deploy.yaml -p NAME=test
oc new-app -f example-client-deploy.yaml -p PREFIX=test -p KDC_SERVER=test

# wait for Pods to start and be running
watch_deploy test $project_name
watch_deploy test-example-app $project_name

server_pod=$(oc get pod -l app=krb5-server -o name)
admin_pwd=$(oc logs -c kdc $server_pod | head -n 1 | sed 's/.*Your\ KDC\ password\ is\ //')

app_pod=$(oc get pods -l app=client -o name)

principal=$(oc set env $app_pod --list | grep OPTIONS | grep -o "[a-z]*\@[A-Z\.]*")
realm=$(echo $principal | sed 's/[a-z]*\@//')

# create principal
echo $admin_pwd | oc rsh -c kinit-sidecar $app_pod kadmin -r $realm -p admin/admin@$realm -q "addprinc -pw redhat -requires_preauth $principal"

# create keytab
echo $admin_pwd | oc rsh -c kinit-sidecar $app_pod kadmin -r $realm -p admin/admin@$realm -q "ktadd $principal"

# watch app logs
oc logs -f $app_pod -c example-app
