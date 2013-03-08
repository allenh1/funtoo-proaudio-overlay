# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwt/qwt-5_pre20060130.ebuild,v 1.3 2006/07/21 17:55:57 caleb Exp $

EAPI=5

inherit multilib eutils cvs

MY_P="qwt"
HOMEPAGE="http://qwt.sourceforge.net/"
DESCRIPTION="2D plotting library for Qt4"
HOMEPAGE="http://qwt.sourceforge.net/"
LICENSE="qwt"
KEYWORDS=""
SLOT="5"
ECVS_SERVER="qwt.cvs.sourceforge.net:/cvsroot/qwt"
ECVS_MODULE="qwt"

IUSE="doc svg"

QWTVER="5.0.0"

DEPEND="
	dev-qt/qtgui:4
	svg? ( dev-qt/qtsvg:4 )
	>=sys-apps/sed-4"

S="${WORKDIR}/${ECVS_MODULE}"

src_unpack () {
	cvs_src_unpack
}

src_prepare () {
	find . -type f -name "*.pro" | while read file; do
		sed -e 's/.*no-exceptions.*//g' -i "${file}"
		echo >> "${file}" "QMAKE_CFLAGS_RELEASE += ${CFLAGS}"
		echo >> "${file}" "QMAKE_CXXFLAGS_RELEASE += ${CXXFLAGS}"
	done
	find examples -type f -name "*.pro" | while read file; do
		echo >> "${file}" "INCLUDEPATH += /usr/include/qwt"
	done
}

src_compile () {
	/usr/bin/qmake qwt.pro
	emake || die

	cd designer
	/usr/bin/qmake qwtplugin.pro
	emake || die
}

src_install () {
	ls -l lib
	dolib lib/libqwt.so.${QWTVER}
	dosym libqwt.so.${QWTVER} /usr/$(get_libdir)/libqwt.so
	dosym libqwt.so.${QWTVER} /usr/$(get_libdir)/libqwt.so.${QWTVER/.*/}
	dosym libqwt.so.${QWTVER} /usr/$(get_libdir)/libqwt.so.${QWTVER/.*/.0}
	use doc && (dodir /usr/share/doc/${PF}
				cp -pPR examples "${D}/usr/share/doc/${PF}/"
				dohtml doc/html/*)
	mkdir -p "${D}"/usr/include/qwt5/
	install include/* "${D}"/usr/include/qwt5/
	insinto /usr/$(get_libdir)/qt4/plugins/designer
	doins designer/plugins/designer/libqwt_designer_plugin.so
}
