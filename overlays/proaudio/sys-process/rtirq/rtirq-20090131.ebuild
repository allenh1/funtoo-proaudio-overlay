# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
inherit exteutils
DESCRIPTION="Change the realtime scheduling policy and priority of relevant system driver IRQ handlers"
HOMEPAGE="http://www.rncbc.org/jack/"

P_URL="http://www.rncbc.org/jack"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="|| ( >=sys-apps/util-linux-2.13 sys-process/schedutils )
		sys-apps/sysvinit"

src_unpack(){
	unpack ${A}
	cd "${S}"
	gzip -cdf "${FILESDIR}/rt-initscript.gz" >  rtirq
	# use fullstatus to show the status of rtirq.sh
	esed_check  -i -e '/depend(/'i"opts=\"fullstatus\"\n" \
		-e 's@\(^status(.*\)@full\1@g' rtirq

	# set path for cfg file
	esed_check -ie "s:^\(RTIRQ_CONFIG\=\)\(.*\):\1/etc/conf.d/rtirq:" rtirq.sh

	# cfg path
	esed_check -i -e "s:/etc/sysconfig/rtirq:/etc/conf.d/rtirq:" rtirq.conf

	# fixup to work with different kernels
	# see http://article.gmane.org/gmane.linux.gentoo.proaudio/2497
	esed_check -i -e 's@\(egrep.*\)softirq\(.*\)@\1s(oft)?irq\2@g' rtirq.sh
}

src_install(){
	exeinto /etc/init.d
	doexe rtirq rtirq.sh
	insinto /etc/conf.d
	newins rtirq.conf rtirq
}

pkg_postinst(){
	elog "now add the script to your runlevel"
	elog "e.g. rc-update add rtirq default"
	elog "config-file: /etc/conf.d/rtirq"
	elog
	elog "You need an realtime-kernel to use this init-script:"
	elog "kernel-patch: redhat.com/~mingo/realtime-preempt"
	elog "select: (X) Complete Preemption (Real-Time) in kernel-config."
	elog "Easy way to get an realtime kernel try:"
	elog "emerge rt-sources from the proaudio overlay"
	elog
	elog "To display the full status of the rtirq script use:"
	elog "/etc/init.d/rtirq fullstatus"
}
