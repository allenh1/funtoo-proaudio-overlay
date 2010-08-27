# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit base eutils versionator

MY_PV=$(delete_version_separator '_')
MY_P="${PN}-${MY_PV}"
MY_S="${WORKDIR}/${MY_P}"

DESCRIPTION="An automated system for acquisition, management, scheduling and playout of audio content."
HOMEPAGE="http://rivendellaudio.org/"
SRC_URI="http://rivendellaudio.org/ftpdocs/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa gpio mpeg mp2 mp3 pam"

RESTRICT="nomirror"

DEPEND="alsa? ( media-libs/alsa-lib )
	media-sound/jack-audio-connection-kit
	mpeg? ( media-libs/libmad )
	media-libs/flac
	media-libs/id3lib
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/libsoundtouch
	virtual/mysql
	x11-libs/qt:3[mysql]"
RDEPEND="${DEPEND}
	mp2? ( media-sound/twolame )
	mp3? ( media-sound/lame )
	pam? ( sys-libs/pam )
	app-cdr/cdrkit
	media-sound/cdparanoia
	media-sound/lame
	media-sound/mpg321
	media-sound/vorbis-tools
	net-misc/curl
	sys-devel/bc"

pkg_setup() {
	enewgroup ${PN} 150
	enewuser ${PN} 150 -1 /var/lib/${PN} "${PN},audio"
}

src_prepare() {
	cd "${MY_S}"
	epatch "${FILESDIR}/initscript.patch"
	epatch "${FILESDIR}/sandbox.patch"
}

src_configure() {
	cd "${MY_S}"
	local myconf="--libexecdir=/usr/libexec/rd-bin"

	use alsa || myconf="${myconf} --disable-alsa"
	use gpio || myconf="${myconf} --disable-gpio"
	use mpeg || myconf="${myconf} --disable-mad"
	use mp2 || myconf="${myconf} --disable-twolame"
	use mp3 || myconf="${myconf} --disable-lame"
	use pam || myconf="${myconf} --disable-pam"

	econf ${myconf}
}

src_compile () {
	cd "${MY_S}"
	emake || die "make failed"
}

src_install() {
	cd "${MY_S}"
	emake DESTDIR="${D}" install || die "install failed"

	insinto /etc
	doins conf/rd.conf-sample

	keepdir /var/snd
	fowners ${PN}:${PN} /var/snd
	fperms 0775 /var/snd
	fperms 0664 /var/snd/*

	dodoc AUTHORS ChangeLog NEWS README UPGRADING docs/*.txt conf/*.conf
	prepalldocs
}

pkg_postinst() {
	einfo "If you would like ASI hardware support, install those drivers and"
	einfo "re-emerge this package."
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
