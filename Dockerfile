FROM centos:7

ENV container docker
ARG ANSIBLE_VERSION=2.7.1
ARG MOLECULE_VERSION=2.19.0

# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install requirements.
RUN yum makecache fast \
  && yum -y install deltarpm epel-release initscripts \
  && yum -y update \
  && yum -y install \
      sudo \
      which \
      python-pip \
      gcc \
      python-devel \
      openssh-clients \
      git \
      https://releases.hashicorp.com/vagrant/2.2.3/vagrant_2.2.3_x86_64.rpm \
      libvirt \
      libvirt-devel \
      libvirt-python \
      virt-install \
  && yum install -y libtool-ltdl \
  && yum remove python-requests -y \
  && yum clean all \
  && vagrant plugin install vagrant-libvirt

RUN pip install --upgrade \
      pip \
      setuptools \
  && pip install --no-cache-dir \
      ansible==${ANSIBLE_VERSION} \
      molecule==${MOLECULE_VERSION} \
      docker \
      python-vagrant

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts
COPY ansible.cfg /etc/ansible/ansible.cfg

# Keys to access repo and verify host
RUN mkdir -p /root/.ssh/ \
  && chmod 700 ~/.ssh \
  && ssh-keyscan -H git.zdt.io >> /root/.ssh/known_hosts \
  && chmod 644 /root/.ssh/known_hosts

#CMD ["/usr/sbin/init"]
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/lib/systemd/systemd"]
