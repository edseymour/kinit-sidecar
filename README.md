# kinit-sidecar

Drop keytabs in /krb5 directory. Expects:
* krb5.keytab as a default keytab
* client.keytab as default client keytab

Or alternatively pass following options:
* OPTIONS - override kinit options
* APPEND_OPTIONS - append to kinit options

Drop realm and other configuration into /etc/krb5.conf.d
