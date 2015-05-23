# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion python qt4-r2

DESCRIPTION="CLAM's visual builder"
HOMEPAGE="http://clam-project.org/index.html"

SRC_URI=""
ESVN_REPO_URI="http://clam-project.org/clam/trunk"
ESVN_PROJECT="clam"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="mirror"

PYTHON_DEPEND="2:7"

DEPEND=">=media-libs/libclam-9999
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtxmlpatterns
	dev-qt/qtopengl
	dev-qt/qtsvg
	dev-python/shiboken"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

QTDIR=""

S="${WORKDIR}/${PN}"
MY_S="${S}/${PN}"

pkg_setup() {
	python_set_active_version 2
}

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	cd "${MY_S}"
	sed -i -e "s/shiboken/shiboken-python2.7/" SConstruct || die "sed failed"
	sed -i -e "s/boost_python/boost_python-2.7/" SConstruct || die "sed failed"
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p "${D}"/usr
	addpredict /usr/share/clam/sconstools

	cd "${MY_S}" || die
	scons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" \
		qt_plugins_install_path="/lib/qt4/plugins/designer" || die "Build failed"
	convert -resize 48x48 -colors 24 src/images/NetworkEditor-icon.png clam-networkeditor.xpm || die "convert NE icon failed"
	convert -resize 48x48 -colors 24 src/images/Prototyper-icon.png clam-prototyper.xpm || die "convert P icon failed"
}

src_install() {
	cd ${MY_S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES README || die "dodoc failed"
	insinto /usr/share/pixmaps
	doins *.xpm || die "install icons failed"
}
