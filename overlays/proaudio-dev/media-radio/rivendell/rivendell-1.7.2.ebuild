# Copyright 1999-2010 Gentoo Foundation
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

RESTRICT="nomirror"

DEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	media-libs/flac
	media-libs/id3lib
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libsamplerate
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
	enewgroup ${PN} 585
	enewuser ${PN} 585 -1 /var/lib/${PN} "${PN},audio"
}

src_prepare() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-init.patch"
	epatch "${FILESDIR}/${P}.patch"
}

src_configure() {
	local myconf="--libexecdir=/usr/libexec/rd-bin"

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

	dodoc AUTHORS ChangeLog INSTALL NEWS README SupportedCards docs/*.txt
	prepalldocs
}

pkg_postinst() {
	elog "If you would like ASI or GPIO hardware support,"
	elog "install their drivers and re-emerge this package."
	einfo
	einfo "See http://rivendell.tryphon.org/wiki/index.php/Install_under_Gentoo"
	einfo "for Gentoo specific instructions."
	einfo
	ewarn "If ${P} is an update, it may use a new database schema, run rdadmin to ensure your schema is current."
}
