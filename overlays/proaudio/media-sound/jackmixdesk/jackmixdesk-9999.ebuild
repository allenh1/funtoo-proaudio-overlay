# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion autotools eutils

DESCRIPTION="Audio mixer for JACK with OSC control, LASH support and GTK GUI"
HOMEPAGE="http://sourceforge.net/projects/jackmixdesk"
ESVN_REPO_URI="https://jackmixdesk.svn.sourceforge.net/svnroot/jackmixdesk/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100.0
	=x11-libs/gtk+-2*
	media-sound/lash
	media-libs/liblo
	net-dns/libidn"
DEPEND="${RDEPEND}
	>=dev-libs/libxml2-2.6.28
	virtual/pkgconfig"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install
	dodoc README ChangeLog AUTHORS TODO
	make_desktop_entry "${PN}"_gtk JackMixDesk "${PN}" "AudioVideo;Audio;Mixer"
	doicon doc/"${PN}".png
}

pkg_preinst() {
	rm -r "${D}/usr/share/doc/${PN}-0.4/" || die "rm failed"
}
