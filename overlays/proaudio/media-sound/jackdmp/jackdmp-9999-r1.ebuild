# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion flag-o-matic 

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"

ESVN_REPO_URI="http://subversion.jackaudio.org/jackmp/trunk/jackmp/"
RESTRICT="nomirror ccache"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc debug examples freebob"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1
	freebob? ( sys-libs/libfreebob )
	!<media-sound/jack-audio-connection-kit-9999"

DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/scons
	doc? ( app-doc/doxygen )"

src_compile() {
	local myconf="PREFIX=/usr"
	use freebob || myconf="${myconf} ENABLE_FREEBOB=False ENABLE_FIREWIRE=False"
	use debug || myconf="${myconf} DEBUG=False"
	use doc || myconf="${myconf} BUILD_DOXYGEN_DOCS=False"
	use examples || myconf="${myconf} BUILD_EXAMPLES=False"
	scons ${myconf} || die
}

src_install() {
	scons PREFIX="${D}/usr"	install || die
	dodoc Readme Todo ChangeLog
}
