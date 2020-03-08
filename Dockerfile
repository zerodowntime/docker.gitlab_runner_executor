FROM centos:7 as vagrant_libvirt_builder

RUN set -eux; \
  # Install vagrant-libvirt dependencies
  yum -y install \
  gcc \
  https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm \
  virt-install \
  libvirt \
  libvirt-devel; \
  # Build vagrant-libvirt plugin
  vagrant plugin install vagrant-libvirt

# ============================================

FROM centos:7
ENV container docker
WORKDIR /root/

RUN set -eux; \
  # Install base
  yum makecache fast; \
  yum -y install epel-release; \
  yum -y update; \
  yum -y install \
  sudo \
  which \
  vim; \
  # Install molecule requirements  
  yum -y install \
  gcc \
  python3-pip \
  python3-devel \
  openssh-clients \ 
  openssl-devel \ 
  libselinux-python \
  git; \
  # Install vagrant  
  yum -y install \
  https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm \
  libvirt-libs; \
  # Clean up mess
  yum clean all

# Place libvirt plugin    
COPY --from=vagrant_libvirt_builder /root/.vagrant.d/plugins.json /root/.vagrant.d/plugins.json
COPY --from=vagrant_libvirt_builder /root/.vagrant.d/gems/2.4.9/ /root/.vagrant.d/gems/2.4.9/

ARG ANSIBLE_VERSION=2.8.0
ARG MOLECULE_VERSION=3.0

RUN set -eux; \
  # Pip
  python3 -m pip install --no-cache-dir --upgrade \
  pip \
  setuptools; \
  # Molcule drivers
  python3 -m pip install --no-cache-dir \
  docker \
  python-vagrant; \
  # Molecule
  python3 -m pip install --no-cache-dir \
  molecule==${MOLECULE_VERSION}.* \
  molecule-vagrant \
  ansible-lint \
  flake8 \
  yamllint \
  ansible==${ANSIBLE_VERSION}.*

# Disable requiretty.
RUN set -eux; \
  sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN set -eux; \
  mkdir -p /etc/ansible; \
  echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts
COPY ansible.cfg /etc/ansible/ansible.cfg

# Keys to access repo and verify host
RUN set -eux; \
  mkdir -p /root/.ssh/; \
  chmod 700 ~/.ssh; \
  ssh-keyscan -H git.zdt.io >> /root/.ssh/known_hosts; \
  chmod 644 /root/.ssh/known_hosts
