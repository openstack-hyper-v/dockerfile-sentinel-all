FROM ubuntu:14.04
 
RUN apt-get install wget -y
RUN wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
RUN dpkg -i puppetlabs-release-trusty.deb
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get install expect -y
RUN apt-get install ruby -y
RUN apt-get install ruby-dev -y
RUN apt-get install git -y
RUN apt-get install screen -y
RUN apt-get install ipmitool -y
RUN apt-get install OpenIPMI -y
RUN apt-get install openssh-server -y
RUN apt-get install openjdk-7-jdk -y
RUN apt-get install puppet -y
RUN gem install r10k

RUN gem install hiera-eyaml
RUN echo "root:ubuntu" | chpasswd
RUN useradd jenkins
RUN echo "jenkins:jenkins" | chpasswd
RUN mkdir /var/run/sshd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
 
#RUN apt-get install software-properties-common -y
#RUN add-apt-repository ppa:maas/stable
#RUN apt-get update
#RUN apt-get install maas-cluster-controller
 
RUN puppet module install puppetlabs-stdlib
RUN puppet module install puppetlabs-apt

#RUN git clone https://github.com/ppouliot/puppet-maas /etc/puppet/modules/maas
ADD site.pp /etc/puppet/manifests/site.pp
ADD do-maas.sh /etc/do-maas.sh

ADD sentinel_startup.sh /etc/sentinel_startup.sh
EXPOSE 22
EXPOSE 3141
RUN /usr/sbin/sshd -D &
RUN wget http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.24/swarm-client-1.24-jar-with-dependencies.jar

RUN /etc/do-maas.sh
