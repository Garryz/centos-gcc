FROM centos:centos6

RUN rpm --rebuilddb \
	&& rpm --import \
		http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6 \
	&& rpm --import \
		https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 \
	&& rpm --import \
		https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY \
	&& yum -y install \
		centos-release-scl \
		centos-release-scl-rh \
		epel-release \
		https://centos6.iuscommunity.org/ius-release.rpm \
		openssh-server \
		pwgen \
	&& rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key \
	&& ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key \
	&& ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key \
	&& sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
	&& sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config \
	&& rpm --import \
		/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo \
	&& yum -y install \
		devtoolset-3-gcc \
		devtoolset-3-gcc-c++ \
		devtoolset-3-gdb \
		rh-python35 \
		cmake3 \
		lrzsz \
		vim \
		git \
		ctags \
		mlocate \
		wget \
		xz \
	&& rm -rf /usr/bin/cmake \
	&& ln -s /usr/bin/cmake3 /usr/bin/cmake \
	&& yum clean all \
	&& find /usr/share \
		-type f \
		-regextype posix-extended \
		-regex '.*\.(jpg|png)$' \
		-delete \
	&& rm -rf /etc/ld.so.cache \
	&& rm -rf /sbin/sln \
	&& rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh/devtoolset-3/root/usr/{{lib,share}/locale,share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh-python35/root/usr/{{lib,share}/locale,share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/* \
	&& > /etc/sysconfig/i18n

RUN ln -sf \
		/usr/share/zoneinfo/UTC \
		/etc/localtime \
	&& echo "NETWORKING=yes" > /etc/sysconfig/network

ADD gcc.sh /etc/profile.d/
ADD gcc.csh /etc/profile.d/
ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS **None**

EXPOSE 22
CMD ["/run.sh"]
