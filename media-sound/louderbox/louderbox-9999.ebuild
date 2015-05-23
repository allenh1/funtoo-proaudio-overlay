# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

DESCRIPTION="Louderbox is a complete 8 band audio processor intended to be used
with software stereo and R[B]DS generators (but perfectly usable for other
things (such as web \"radio\")"
HOMEPAGE="http://www.spamblock.demon.co.uk/louderbox.html"

ECVS_SERVER="airchain.salemradiolabs.com:/home/cvs"
ECVS_MODULE="louderbox"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${RDEPEND}
		>=media-sound/jack-audio-connection-kit-0.100
		>=media-libs/ladspa-sdk-0.12
		>=media-plugins/swh-plugins-0.4.7
		>=media-plugins/tap-plugins-0.7.0
		!media-sound/louderbox-cvs"
RDEPEND="=x11-libs/gtk+-2*
		=gnome-base/libglade-2*"

src_compile() {
	epatch ${FILESDIR}/${PN}-configure.patch
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}

