# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=yes
inherit autotools-utils eutils python-single-r1 multilib-minimal

MY_PV="${PV/_/\~}"
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

RDEPEND="
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	media-sound/jack-audio-connection-kit[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-apps/util-linux[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	python? ( ${PYTHON_DEPS} )
	|| ( sys-libs/readline:= dev-libs/libedit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( dev-lang/swig )"

S="${WORKDIR}/${MY_PN}-0.6.0.594"

PATCHES=(
	"${FILESDIR}"/${P}-aclocal.patch
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-underlinking.patch
)

multilib_src_configure() {
	# Generation of docs does no longer work. Hard disable it.
	export ac_cv_prog_lash_texi2html="no"

	local myeconfargs=(
		$(use_enable debug)
		$(multilib_native_use_with alsa)
		$(multilib_native_use_with gtk gtk2)
		$(multilib_native_use_with python)
	)

	autotools-utils_src_configure
}

multilib_src_compile() {
	autotools-utils_src_compile
}

multilib_src_install() {
	autotools-utils_src_install
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
	use python && python_optimize
}

pkg_postinst() {
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

pkg_postrm() {
	# cleanup /etc/services
	if grep -q ^lash /etc/services; then
		einfo "cleaning lash entries frome /etc/services"
		sed -i /lash/d /etc/services
	fi
	# cleanup trailing blank lines in /etc/service
	sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/services
}
