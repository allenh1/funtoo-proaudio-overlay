# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit autotools-utils eutils python-single-r1

MY_PV="${PV/_/~}"
MY_PN="${PN/-original/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash/"
SRC_URI="http://download.savannah.gnu.org/releases/${MY_PN}/${MY_P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa debug gtk python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="alsa? ( media-libs/alsa-lib )
	media-sound/jack-audio-connection-kit
	dev-libs/libxml2
	gtk? ( >=x11-libs/gtk+-2.0 )
	python? ( ${PYTHON_DEPS} )
	|| ( sys-libs/readline dev-libs/libedit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-lang/swig-1.3.31 )"

S="${WORKDIR}/${MY_PN}-0.6.0.594"

PATCHES=( "${FILESDIR}/${P}-include.patch" )

src_configure() {

	# Generation of docs does no longer work. Hard disable it.
	export ac_cv_prog_lash_texi2html="no"

	local myeconfargs=(
		$(use_enable debug)
		$(use_with alsa)
		$(use_with gtk gtk2)
		$(use_with python)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	python_fix_shebang "${ED}"
}

pkg_postinst(){
	if [ ! $(grep -q ^lash /etc/services) ] || [ $(grep -q ^ladcca /etc/services) ] ; then
		# cleanup trailing blank lines in /etc/service
		sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/services
		# check for old ladcca entries and remove
		if grep -q ^ladcca /etc/services; then
			sed -i /ladcca/d /etc/services
		fi
		# add new lash entry
		if ! grep -q ^lash /etc/services ; then
			cat >>/etc/services<<-EOF

lash		14541/tcp			# LASH client/server protocol
EOF
		fi
	fi
}

pkg_postrm(){
	# cleanup /etc/services
	if grep -q ^lash /etc/services; then
		einfo "cleaning lash entries frome /etc/services"
		sed -i /lash/d /etc/services
	fi
	# cleanup trailing blank lines in /etc/service
	sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/services
	einfo "if programs which use lash fails try:"
	einfo "revdep-rebuild --library="liblash.so.*""
}
