FROM opensuse:13.2
MAINTAINER ppouliot@microsoft.com
ENV CONCURRENCY_LEVEL 16

RUN zypper refresh && zypper -n install ca-certificates yum-utils curl wget expect unzip screen iputils openssh freeipmi freeipmi-bmc-watchdog freeipmi-ipmidetectd OpenIPMI docker createrepo python python-d2to1 python-setuptools python-py python-pytz python-requests python-glanceclient python-glanceclient-test python-jenkinsapi python-pysnmp zypper
RUN zypper refresh && zypper -n install -t pattern devel_C_C++ devel_rpm_build remote_desktop

RUN zypper -n --gpg-auto-import-keys ref \
    && zypper ar http://download.opensuse.org/repositories/systemsmanagement:/puppet/openSUSE_13.2/ systemsmanagement:puppet \
#    && zypper ar http://download.opensuse.org/repositories/systemsmanagement:/chef/openSUSE_Factory/ systemsmanagement:chef \
    && zypper ar http://download.opensuse.org/repositories/Java:/Factory/openSUSE_13.2 Java:Factory \
    && zypper -n --gpg-auto-import-keys  ref \
    && zypper -n install java-1_8_0-openjdk \
    && zypper -n install -l --force-resolution  puppet \
#    && sed -ri 's/^(rpm.install.excludedocs.=).*/\1 no/g' /etc/zypp/zypp.conf \
#    && sed -ri 's/^(rpm.install.excludedocs.=).*/\1 yes/g' /etc/zypp/zypp.conf \
    && zypper clean -a

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



RUN cd /opt/jenkins/ && /usr/bin/wget -cv https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.3/swarm-client-3.3.jar
RUN wget https://raw.githubusercontent.com/openstack-hyper-v/dockerfile-sentinel-all/master/startup_slave33.sh
RUN cd /opt/jenkins/ && /usr/bin/wget -cv https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4.jar
RUN wget https://raw.githubusercontent.com/openstack-hyper-v/dockerfile-sentinel-all/master/startup_slave34.sh
RUN cd /opt/jenkins/ && /usr/bin/wget -cv https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar
RUN wget https://raw.githubusercontent.com/openstack-hyper-v/dockerfile-sentinel-all/master/startup_slave.sh
RUN wget https://raw.githubusercontent.com/openstack-hyper-v/dockerfile-sentinel-all/master/build_upstream_kernel_rpm.sh


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
