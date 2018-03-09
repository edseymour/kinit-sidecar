FROM centos:centos7

ADD rekinit.sh /
ADD krb5.conf /etc/krb5.conf

RUN yum install -y krb5-workstation && \
    mkdir /krb5 && chmod 755 /krb5 

VOLUME ["/krb5","/dev/shm","/etc/krb5.conf.d"]

USER 1001

ENTRYPOINT ["/rekinit.sh"]

