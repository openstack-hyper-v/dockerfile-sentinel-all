FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
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
RUN wget http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar
RUN echo "\n\
echo "Starting up connection to $1 using name: $2" \n\
java -jar swarm-client-1.24-jar-with-dependencies.jar -master $1 -executors 1 -password jenkins -name $2 -username jenkins \n\
" >> /etc/sentinel_startup.sh
EXPOSE 22
EXPOSE 3141
RUN /usr/sbin/sshd -D &
