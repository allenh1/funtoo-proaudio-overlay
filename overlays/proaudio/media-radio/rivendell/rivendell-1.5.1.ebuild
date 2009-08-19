# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit base eutils autotools

DESCRIPTION="An automated system for acquisition, management, scheduling and playout of audio content."
HOMEPAGE="http://rivendellaudio.org/"
SRC_URI="http://rivendellaudio.org/ftpdocs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack pam"

RESTRICT="nomirror"

DEPEND="alsa? ( media-libs/alsa-lib )
	alsa? ( media-libs/libsamplerate )
	jack? ( media-sound/jack-audio-connection-kit )
	jack? ( media-libs/libsamplerate )
	media-libs/flac
	media-libs/id3lib
	media-libs/libogg
	media-libs/libvorbis
	virtual/mysql
	x11-libs/qt:3"
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
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} "${PN},audio"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-init.patch"
	epatch "${FILESDIR}/${PN}-sandbox.patch"
}

src_compile() {
	local myconf=""

	use alsa || myconf="${myconf} --disable-alsa"
	use jack || myconf="${myconf} --disable-jack"
	use pam || myconf="${myconf} --disable-pam"

	econf ${myconf}
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	insinto /etc
	doins conf/rd.conf-sample || die "install /etc/rd.conf failed"

	keepdir /var/snd || die "keepdir failed"
	fowners ${PN}:${PN} /var/snd || die "fowners failed"

	dodoc AUTHORS ChangeLog INSTALL NEWS README SupportedCards docs/*.txt || die "install doc failed"
	prepalldocs || die "prepalldocs failed"
}

pkg_postinst() {
	elog "If you would like ASI or GPIO hardware support,"
	elog "install their drivers and re-emerge this package."
	einfo
	einfo "If this is a fresh install you will need to modify"
	einfo "the /etc/rd.conf file and use rdadmin to initialize"
	einfo "the Rivendell database before starting"
	einfo "/etc/init.d/rivendell."
	einfo "/var/snd is owned by ${PN}:${PN}."
	einfo "Set AudioOwner and AudioGroup into /etc/rd.conf"
	einfo "accordingly."
	einfo
	ewarn "If this is an upgrade, run rdadmin to ensure your"
	ewarn "database schema is up to date"
}
