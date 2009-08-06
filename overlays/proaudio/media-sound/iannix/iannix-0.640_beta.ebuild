# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit exteutils

MY_P="IanniX-${PV/_beta/b}"

DESCRIPTION="IanniX is a graphical score editor based on the previous UPIC developed by Iannis Xenakis"
HOMEPAGE="http://sourceforge.net/projects/iannix/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-SRC-LittleEndian.tgz
		doc? ( mirror://sourceforge/${PN}/IanniX-Tutorial.pdf )
		examples? (	mirror://sourceforge/${PN}/IanniX-Examples-Processing-1.5.tgz )"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples"

S="${WORKDIR}/IanniX SRC Little Endian"

DEPEND="${RDEPEND}"
RDEPEND="|| ( ( x11-libs/qt-core
		x11-libs/qt-gui
		x11-libs/qt-sql
		x11-libs/qt-test
		x11-libs/qt-opengl
		x11-libs/qt-svg )
		>=x11-libs/qt-4.2:4 )"

pkg_setup() {
	if ! has_version x11-libs/qt-opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for $PN requires qt4 to be built with opengl support"
	fi
}

src_compile() {
	cd "${S}"
	# fix Qt4 libdir
	esed_check -i -e "s:/usr/local/Trolltech/Qt-...../lib:/usr/lib/qt4:" IanniX.pro
	
	# make amd64 compile
	use amd64 && esed_check -i -e "45s|<int>|<long>|" \
		-e "60s|<int>|<long>|" \
		-e "61s|<int>|<long>|" \
		src/network/OSCin/osc/OscReceivedElements.cpp
	/usr/bin/qmake || die "qmake failed"
	emake || die "make failed"
}

src_install() {
	dobin bin/IanniX
	dodoc README.txt TODO.txt
	make_desktop_entry IanniX "IanniX"
	if use doc; then
		insinto /usr/share/doc/${P}
		doins "${DISTDIR}"/*.pdf
	fi
	if use examples; then
		mv "${WORKDIR}/IanniX Processing Examples" "${D}"/usr/share/doc/"${P}"
	fi
}

pkg_postinst() {
	einfo "You can start IanniX with"
	einfo ""
	einfo "/usr/bin/IanniX"
	einfo ""

	if use examples; then
		einfo "The examples have been installed to /usr/share/doc/${P}"
	fi

	if use doc; then
		einfo "For documentation read /usr/share/doc/${P}/IanniX-Tutorial.pdf"
	fi
}
