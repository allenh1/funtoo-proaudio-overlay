# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

MY_PV="${PV/_p/-r}"

DESCRIPTION="Audio mixer for JACK with OSC control, LASH support and GTK GUI"
HOMEPAGE="http://sourceforge.net/projects/jackmixdesk"
SRC_URI="mirror://sourceforge/jackmixdesk/jackmixdesk-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${MY_PV}"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100.0
	=x11-libs/gtk+-2*
	>=media-sound/lash-0.5.4-r1
	>=media-libs/liblo-0.25
	>=net-dns/libidn-1.13"
DEPEND="${RDEPEND}
	>=dev-libs/libxml2-2.6.28
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf || die "autoconf failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README ChangeLog AUTHORS TODO
	make_desktop_entry "${PN}"_gtk JackMixDesk "${PN}" "AudioVideo;Audio;Mixer"
	doicon doc/"${PN}".png
}

pkg_preinst() {
	rm -r "${D}/usr/share/doc/${PN}-${MY_PV}/" || die "rm failed"
}
