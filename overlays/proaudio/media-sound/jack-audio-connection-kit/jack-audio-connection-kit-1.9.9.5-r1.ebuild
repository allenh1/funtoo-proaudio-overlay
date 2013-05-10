# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 waf-utils

RESTRICT="mirror"
DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="https://dl.dropbox.com/u/28869550/jack-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa dbus debug doc freebob ieee1394 mixed"

RDEPEND="media-libs/libsamplerate
	>=media-libs/libsndfile-1.0.0
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	dbus? ( sys-apps/dbus )
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	ieee1394? ( media-libs/libffado !sys-libs/libfreebob )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	dbus? ( dev-python/dbus-python )"

S="${WORKDIR}/jack-${PV}"

PATCHES=(
	"${FILESDIR}/jack2-no-self-connect-1.9.9.5.patch"
	"${FILESDIR}/jack-1.9.9.5-opus_custom.patch"
)

DOCS=( ChangeLog README README_NETJACK2 TODO )

pkg_pretend() {
	if use mixed; then
		ewarn 'You are about to build with "mixed" use flag.'
		ewarn 'The build will probably fail.'
		ewarn 'This is a known issue and a fix is coming eventually.'
	fi
}

src_configure() {
	local mywafconfargs=(
		$(usex alsa --alsa "")
		$(usex dbus --dbus --classic)
		$(usex debug --debug "")
		$(usex freebob --freebob "")
		$(usex ieee1394 --firewire "")
		$(usex mixed --mixed "")
	)

	waf-utils_src_configure ${mywafconfargs[@]}
}

src_compile() {
	waf-utils_src_compile

	if use doc; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	use doc && HTML_DOCS=( html/ )
	waf-utils_src_install

	python_fix_shebang "${ED}"
}
