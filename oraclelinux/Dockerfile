FROM oraclelinux:latest

RUN yum install tar -y
RUN yum install bzip2 -y
RUN yum install wget -y
RUN rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
RUN yum update -y
RUN yum install expect -y
RUN yum install ruby -y
RUN yum install git -y
RUN yum install unzip -y
RUN yum install screen -y
RUN yum install -y ipmitool
RUN yum install -y OpenIPMI
RUN yum install -y openssh-server
RUN yum install java-1.7.0-openjdk -y
RUN yum install puppet -y
RUN gem install r10k 
RUN gem install hiera-eyaml 
RUN echo "root:centos" | chpasswd
RUN useradd jenkins
RUN echo "jenkins:jenkins" | chpasswd
RUN mkdir /var/run/sshd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i '/templatedir=$confdir\/templates/d' /etc/puppet/puppet.conf
RUN wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar
RUN wget https://raw.githubusercontent.com/openstack-hyper-v/dockerfile-sentinel-all/master/startup_slave.sh
RUN chmod +x startup_slave.sh
EXPOSE 22
EXPOSE 3141
RUN /usr/sbin/sshd -D &
