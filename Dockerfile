FROM centos:centos7

ADD rekinit.sh /rekinit.sh
ADD krb5.conf /etc/krb5.conf

RUN yum install -y krb5-workstation && \
    mkdir /krb5 && chmod 755 /krb5 && \
    chmod 755 /rekinit.sh

VOLUME ['/krb5','/dev/shm']

USER 1001

CMD ['/rekinit.sh']

