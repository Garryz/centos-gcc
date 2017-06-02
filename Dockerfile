FROM centos:centos6

RUN rpm --rebuilddb \
	&& rpm --import \
		http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6 \
	&& rpm --import \
		https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 \
	&& yum -y install \
		centos-release-scl \
		centos-release-scl-rh \
		epel-release \
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
		cmake \
		ctags \
		gcc \
		gcc-c++ \
		gdb \
		git \
		lrzsz \
		mlocate \
		python27-python \
		python27-python-devel \
		pyhton33-python \
		python33-python-devel \
		wget \
		xz \
		zlib-devel \
	&& cd /tmp \
	&& wget -O gcc.tar http://ftpmirror.gnu.org/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz \
	&& mkdir -p gcc \
	&& tar -xzf gcc.tar -C gcc --strip-components=1 \
	&& cd gcc \
	&& ./contrib/download_prerequisites \
	&& cd .. \
	&& mkdir -p gcc-build \
	&& cd gcc-build \
	&& ../gcc/configure \
		--enable-bootstrap \
		--enable-shared \
		--enable-threads=posix \
		--enable-checking=release \
		--with-system-zlib \
		--enable-__cxa_atexit \
		--disable-libunwind-exceptions \
		--enable-gnu-unique-object \
		--enable-linker-build-id \
		--enable-plugin \
		--with-linker-hash-style=gnu \
		--enable-initfini-array \
		--disable-libgcj \
		--enable-languages=c,c++ \
		--disable-multilib \
		--with-isl \
		--with-ppl \
		--with-cloog \
		--with-tune=generic \
		--with-arch_32=i686 \
		--build=x86_64-redhat-linux \
	&& make -j4 \
	&& make install \
	&& yum -y remove gcc gcc-c++ \
	&& yum clean all \
	&& find /usr/share \
		-type f \
		-regextype posix-extended \
		-regex '.*\.(jpg|png)$' \
		-delete \
	&& rm -rf /etc/ld.so.cache \
	&& rm -rf /sbin/sln \
	&& rm -rf /usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh/python27/root/usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh/python33/root/usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

ADD python33.sh /etc/profile.d/
ADD python33.csh /etc/profile.d/
ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS **None**

EXPOSE 22
CMD ["/run.sh"]
