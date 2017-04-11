FROM opensuse:13.2
MAINTAINER ppouliot@microsoft.com
ENV CONCURRENCY_LEVEL 16

RUN zypper refresh && zypper install -t pattern devel_C_C++ devel_rpm_build remote_desktop && \
zypper install -y curl wget expect unzip screen java_1_7_0-openjdk svn cvs iputils openssh freeipmi freeipmi-bmc-watchdog freeipmi-ipmidetectd OpenIPMI zypper puppet rubygem-puppet docker createrepo python python-d2to1 python-setuptools python-py python-pytz python-requests python-glanceclient python-glanceclient-test python-jenkinsapi python-pysnmp

RUN gem install r10k hiera-eyaml 


###
# # Get the Jenkins Slave and Server Ware files and Create a Startup Script for each
### Valid Jenkins versions are 2.2 and 3.3
# Make the Directory Structure
RUN mkdir /var/run/sshd
RUN mkdir -p /opt/jenkins/swarm ;
RUN mkdir -p /opt/jenkins/logs ;

RUN echo "root:opensuse" | chpasswd
RUN useradd jenkins
RUN echo "jenkins:jenkins" | chpasswd


RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i '/templatedir=$confdir\/templates/d' /etc/puppet/puppet.conf



RUN cd /opt/jenkins/bin/ && echo "*** Downloading Jenkins Swarm Slave 3.3 ***" && \
wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.3/swarm-client-3.3-jar-with-dependencies.jar swarm-client-3.3-jar-with-dependencies.jar 2> ../logs/01-get_jenkins33.sh.log

RUN echo "*** Creating Jenkins 3.3 Swarm Slave Startup Script ***" && \
echo '#
#!/bin/bash
echo Starting up connection to $1 using name: $2
java -jar swarm-client-2.2-jar-with-dependencies.jar -master $1 -executors 2 -name $2' > ./start_slave_22.sh

RUN cd /opt/jenkins/bin/ && echo "*** Downloading Jenkins Swarm Slave 2.2 ***" && \
wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar swarm-client-2.2-jar-with-dependencies.jar 2> ../logs/01-get_jenkins22.sh.log

RUN echo "*** Creating Jenkins 2.2 Swarm Slave Startup Script ***" && \
echo '#
#!/bin/bash
echo Starting up connection to $1 using name: $2
java -jar swarm-client-2.2-jar-with-dependencies.jar -master $1 -executors 2 -name $2' > ./start_slave_22.sh


RUN zypper refresh && zypper install -t pattern devel_C_C++ devel_rpm_build remote_desktop && \
zypper install -y curl wget svn cvs iputils openssh freeipmi freeipmi-bmc-watchdog freeipmi-ipmidetectd OpenIPMI zypper puppet rubygem-puppet docker createrepo python python-d2to1 python-setuptools python-py python-pytz python-requests python-glanceclient python-glanceclient-test python-jenkinsapi python-pysnmp

RUN echo "#!/bin/bash
echo "Clone Upstream Kernel Source
/usr/bin/git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git /usr/src/linux-next 2> ../logs/03-build_kernel_linux_next.sh.log;
# CD to  Kernel Source and Do work
cd /usr/src/linux-next && yes "" |make oldconfig && make rpm;" > build_upstream_kernel.sh

RUN echo "#!/bin/bash
# Blunt force install the packages
rpm -ivh /usr/local/src/packages/RPMS/x86_64/kernel-*.rpm --force ; " > install_upstream_kernel.sh


RUN echo "#!/bin/bash
echo "Clone Upstream Kernel Source
/usr/bin/git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git /usr/src/linux-next 2> ../logs/03-build_kernel_linux_next.sh.log;

# CD to  Kernel Source and Do work
RUN echo "#!/bin/bash
# Blunt force install the packages
rpm -ivh /usr/local/src/packages/RPMS/x86_64/kernel-*.rpm --force ; " > install_upstream_kernel.sh
RUN chmod +x *.sh

EXPOSE 22
EXPOSE 3141
RUN /usr/sbin/sshd -D &
