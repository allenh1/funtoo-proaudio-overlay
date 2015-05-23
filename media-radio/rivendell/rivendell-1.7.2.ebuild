# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit base eutils

DESCRIPTION="An automated system for acquisition, management, scheduling and playout of audio content."
HOMEPAGE="http://rivendellaudio.org/"
SRC_URI="http://rivendellaudio.org/ftpdocs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack pam"

RESTRICT="mirror"

DEPEND="alsa? ( media-libs/alsa-lib )
	alsa? ( media-libs/libsamplerate )
	jack? ( media-sound/jack-audio-connection-kit )
	jack? ( media-libs/libsamplerate )
	media-libs/flac
	media-libs/id3lib
	media-libs/libogg
	media-libs/libvorbis
	virtual/mysql
	x11-libs/qt:3[mysql]"
RDEPEND="${DEPEND}
	pam? ( sys-libs/pam )
	app-cdr/cdrkit
	media-sound/cdparanoia
	media-sound/lame
	media-sound/mpg321
	media-sound/vorbis-tools
	net-ftp/lftp
	net-misc/wget"

pkg_setup() {
	enewgroup ${PN} 150
	enewuser ${PN} 150 -1 /var/lib/${PN} "${PN},audio"
}

src_prepare() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/init.patch"
	epatch "${FILESDIR}/sandbox.patch"
}

src_configure() {
	local myconf="--libexecdir=/usr/libexec/${PN}"

	use alsa || myconf="${myconf} --disable-alsa"
	use jack || myconf="${myconf} --disable-jack"
	use pam || myconf="${myconf} --disable-pam"

	econf ${myconf}
}

src_compile () {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	insinto /etc
	doins conf/rd.conf-sample

	keepdir /var/snd
	fowners ${PN}:${PN} /var/snd
	fperms 775 /var/snd
	fperms 0664 /var/snd/*
	
	newicon icons/rivendell-48x48.xpm ${PN}.xpm
	domenu xdg/${PN}-*.desktop

	dodoc AUTHORS ChangeLog INSTALL NEWS README SupportedCardm docs/*.txt
	prepalldocs
}

pkg_postinst() {
	einfo
	einfo "See http://rivendell.tryphon.org/wiki/index.php/Install_under_Gentoo"
	einfo "for Gentoo specific instructions."
	einfo
	ewarn "If ${P} comes as an update, it may use a new database schema, run rdadmin to ensure your schema is current."
}
