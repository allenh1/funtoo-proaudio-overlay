# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit base eutils depend.apache

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
	dev-qt/qtsql[mysql]"
RDEPEND="${DEPEND}
	lame? ( media-sound/lame )
	twolame? ( media-sound/twolame )
	pam? ( sys-libs/pam )
	app-cdr/cdrkit
	media-sound/cdparanoia
	net-misc/curl"
need_apache2

pkg_setup() {
	enewgroup ${PN} 150
	enewuser ${PN} 150 -1 /var/lib/${PN} "${PN},audio"
}

src_prepare() {
	epatch "${FILESDIR}/sandbox.patch"
}

src_configure() {
	local myconf="--libexecdir=/usr/libexec/${PN}"

	use alsa || myconf="${myconf} --disable-alsa"
	use gpio || myconf="${myconf} --disable-gpio"
	use hpi || myconf="${myconf} --disable-hpi"
	use jack || myconf="${myconf} --disable-jack"
	use mad || myconf="${myconf} --disable-mad"
	use twolame || myconf="${myconf} --disable-twolame"
	use lame || myconf="${myconf} --disable-lame"
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

	echo "<IfDefine RIVENDELL>" > 50_${PN}.conf
	sed '/^\#/d' conf/rd-bin.conf >> 50_${PN}.conf
	echo "</IfDefine>" >> 50_${PN}.conf

	insinto ${APACHE_MODULES_CONFDIR}
	doins 50_${PN}.conf

	newicon icons/rivendell-48x48.xpm ${PN}.xpm
	domenu xdg/${PN}-*.desktop

	dodoc AUTHORS ChangeLog NEWS README UPGRADING docs/*.txt conf/*.conf
}

pkg_postinst() {

	einfo
	einfo "See http://rivendell.tryphon.org/wiki/index.php/Install_under_Gentoo"
	einfo "for Gentoo specific instructions."
	einfo
	einfo "To enable web services, add '-D RIVENDELL'"
	einfo "to APACHE2_OPTS in /etc/conf.d/apache"
	einfo
	ewarn "If this is an update, read /usr/share/doc/${P}/UPGRADING.bz2"
}
