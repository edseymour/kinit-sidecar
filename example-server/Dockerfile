FROM centos:centos7

MAINTAINER eseymour@redhat.com

# install kdc and kadmin
RUN yum install -y krb5-server krb5-workstation && yum clean all
RUN mkdir /var/kerberos/krb5kdc.d && chmod 775 /var/kerberos/krb5kdc.d && chmod 775 /var/kerberos/krb5kdc
ADD init.sh /
ADD kdc.conf /var/kerberos/krb5kdc/
ADD krb5.conf /etc/

VOLUME ["/var/kerberos/krb5kdc","/var/kerberos/krb5kdc.d", "/etc/krb5.conf.d" , "/dev/shm/krb5" ]
EXPOSE 8888 8644 8749

ENTRYPOINT ["/init.sh"]
