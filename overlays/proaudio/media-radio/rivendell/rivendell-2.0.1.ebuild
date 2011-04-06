# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit base eutils versionator

DESCRIPTION="An automated system for acquisition, management, scheduling and playout of audio content."
HOMEPAGE="http://rivendellaudio.org/"
SRC_URI="http://rivendellaudio.org/ftpdocs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa flac gpio hpi jack lame mad pam twolame"

DEPEND="alsa? ( media-libs/alsa-lib )
	flac? ( media-libs/flac )
	jack? ( media-sound/jack-audio-connection-kit )
	mad? ( media-libs/libmad )
	media-libs/id3lib
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/libsoundtouch
	virtual/mysql
	x11-libs/qt:3[mysql]"
RDEPEND="${DEPEND}
	lame? ( media-sound/lame )
	twolame? ( media-sound/twolame )
	pam? ( sys-libs/pam )
	app-cdr/cdrkit
	media-sound/cdparanoia
	media-sound/mpg321
	media-sound/vorbis-tools
	net-misc/curl
	sys-devel/bc"

pkg_setup() {
	enewgroup ${PN} 150
	enewuser ${PN} 150 -1 /var/lib/${PN} "${PN},audio"
}

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}/initscript.patch"
	epatch "${FILESDIR}/sandbox.patch"
}

src_configure() {
	cd "${S}"
	local myconf="--libexecdir=/usr/libexec/${PN}"

	use alsa || myconf="${myconf} --disable-alsa"
	use gpio || myconf="${myconf} --disable-gpio"
	use hpi || myconf="${myconf} --disable-hpi"
	use mad || myconf="${myconf} --disable-mad"
	use twolame || myconf="${myconf} --disable-twolame"
	use lame || myconf="${myconf} --disable-lame"
	use pam || myconf="${myconf} --disable-pam"

	econf ${myconf}
}

src_compile () {
	cd "${S}"
	emake || die "make failed"
}

src_install() {
	cd "${S}"
	emake DESTDIR="${D}" install || die "install failed"

	insinto /etc
	doins conf/rd.conf-sample

	keepdir /var/snd
	fowners ${PN}:${PN} /var/snd

	newicon icons/rivendell-48x48.xpm ${PN}.xpm
	domenu xdg/${PN}-*.desktop

	dodoc AUTHORS ChangeLog NEWS README UPGRADING docs/*.txt conf/*.conf
	prepalldocs
}

pkg_postinst() {

	einfo
	einfo "See http://rivendell.tryphon.org/wiki/index.php/Install_under_Gentoo"
	einfo "for Gentoo specific instructions."
	einfo
	einfo "This version of Rivendell makes use of a web services protocol to"
	einfo "accomplish many functions (audio import, export, ripping, etc)."
	einfo "These services require that a CGI-compliant web server be installed"
	einfo "and active on the system. Any server that complies with CGI-1.1"
	einfo "should work, although as of this writing only Apache 2.2 has been"
	einfo "well tested."
	einfo "A configuration for apache is in /usr/share/doc/${P}/rd-bin.conf"
	einfo
	ewarn "If this is an update, read /usr/share/doc/${P}/UPGRADING.bz2"
}
