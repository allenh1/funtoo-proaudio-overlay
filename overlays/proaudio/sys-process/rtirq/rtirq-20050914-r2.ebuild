# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/sys-process/rtirq/rtirq-20050914-r1.ebuild,v 1.1.1.1 2006/04/10 11:35:53 gimpel Exp $

#inherit eutils 
DESCRIPTION="Change the realtime scheduling policy and priority of relevant system driver IRQ handlers"
HOMEPAGE="http://www.rncbc.org/jack/"
SRC_URI=""

LICENSE="gpl"
SLOT="0"
KEYWORDS="x86 amd64 ppc"
IUSE=""

DEPEND="|| ( >=sys-apps/util-linux-2.13 sys-process/schedutils )
		sys-apps/sysvinit"
src_install(){
	cd  ${D}
	bzip2 -dc -k  "${FILESDIR}/rtirq-20050914-v0.1.bz2" |patch -p1
	fperms 755 /etc/init.d/rtirq
	fowners root:root /etc/init.d/rtirq
	# I know its the wrong place to patch :)
	cd etc/init.d
	pwd
	patch -p3 <"${FILESDIR}/pidof_workaround.patch" || die "patching failed"
}

pkg_postinst(){
	einfo "now add the script to your runlevel"
	einfo "e.g. rc-update add rtirq default"
	einfo "config-file: /etc/conf.d/rtirq"

	einfo "You need an realtime-kernel to use this init-script:"
	einfo "kernel-patch: redhat.com/~mingo/realtime-preempt"
	einfo "select: (X) Complete Preemption (Real-Time) in kernel-config."
	einfo "Easy way to get an realtime kernel try:"
	einfo "emerge rt-sources from the proaudio overlay"
}
