#!/bin/sh

[[ "$PERIOD_SECONDS" == "" ]] && PERIOD_SECONDS=3600

if [[ "$OPTIONS" == "" ]]; then

  [[ -e /krb5/krb5.keytab ]] && OPTIONS="-k" && echo "*** using host keytab"
  [[ -e /krb5/client.keytab ]] && OPTIONS="-k -i" && echo "*** using client keytab"

fi

if [[ -z "$(ls -A /krb5)" ]]; then
  echo "*** Warning default keytab (/krb5/krb5.keytab) or default client keytab (/krb5/client.keytab) not found"
fi

while true
do
  echo "*** kinit at "+$(date -I)
   kinit -V $OPTIONS $APPEND_OPTIONS
   klist -c /dev/shm/ccache 
   echo "*** Waiting for $PERIOD_SECONDS seconds"
   sleep $PERIOD_SECONDS

done
