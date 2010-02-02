# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils

DESCRIPTION="A high-performance call management and screening system targeted for use in talk radio environments."
HOMEPAGE="http://rivendellaudio.org/ftpdocs/${PN}"
SRC_URI="http://rivendellaudio.org/ftpdocs/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="hpi"

DEPEND="dev-libs/openssl
	virtual/mysql
	x11-libs/qt:3"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-sandbox.patch"
}

src_compile() {
	local myconf=""
	use hpi || myconf="${myconf} --disable-hpi"
	econf ${myconf}
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	#insinto /etc
	#doins conf/rd.conf-sample || die
	dodoc AUTHORS ChangeLog NEWS README  docs/*.txt samples/*.conf || die
	prepalldocs
	cp asterisk ${DESTDIR}/usr/share/${P}/
}

pkg_postinst() {
	einfo "Sample configurations for asterisk lie in /usr/share/${P}/."
}
