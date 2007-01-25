# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils autotools wxwidgets

DESCRIPTION="Wired aims to be a professional music production and creation software running on the Linux operating system."
HOMEPAGE="http://wired.epitech.net"

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/wired/trunk"
ESVN_PROJECT="wired"
#ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="-*"
IUSE="nls pic static debug dssi plugins codecs oss alsa jack"
S="${WORKDIR}/${ESVN_PROJECT}"

DEPEND="media-libs/alsa-lib
	media-libs/libsndfile
	>=x11-libs/gtk+-2.0.0
	>=x11-libs/wxGTK-2.6.2
	>=media-libs/portaudio-19
	>=media-libs/libsoundtouch-1.2.1
	dssi? ( media-libs/dssi )
	!wired-svn/wired-svn"

src_compile() {
	cd "${S}"/wired
	
	WX_GTK_VER=2.6
	need-wxwidgets gtk2
	set-wxconfig gtk2-ansi

	./autogen.sh
	econf \
		--with-wx-config=/usr/lib/wx/config/gtk2-ansi-release-2.6 \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with oss) \
	    $(use_enable debug ) \
	    $(use_enable dssi ) \
	    $(use_enable codecs ) \
	    $(use_enable plugins ) \
		$(use_enable nls) \
		$(use_with pic) \
		$(use_with static) \
	    || die "Configuration failed"
	emake || die "Make failed"
}

src_install() {
	cd "${S}"/wired
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog README
}
