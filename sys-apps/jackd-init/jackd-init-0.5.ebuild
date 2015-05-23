# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs
RESTRICT="mirror"
DESCRIPTION="Launch jackd at bootime with user id and privileges"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

MY_PN="jackd"

DEPEND=""
RDEPEND="sys-apps/sed
	media-sound/qjackctl"

src_unpack(){
	echo "Nothing to unpack"
}

src_compile(){
	gzip -d -c "${FILESDIR}"/jackd-init.d.gz > jackd-init.d || die "extracting init.d file"
	gzip -d -c "${FILESDIR}"/jackd-conf.d.gz > jackd-conf.d || die "extracting init.d file"
}

src_install(){
	newinitd jackd-init.d "${MY_PN}"
	newconfd jackd-conf.d "${MY_PN}"
}

pkg_postinst(){
	ewarn "Before to run this script, you must set the user"
	ewarn "that will use jackd into /etc/conf.d/${MY_PN}"
	ewarn "The script must also be able to find jackd configuration"
	ewarn "file for that user. You can emerge and run qjackctl for that."
	einfo "To add the script to your runlevel, make something like:"
	einfo "rc-update add ${MY_PN} default"
}
