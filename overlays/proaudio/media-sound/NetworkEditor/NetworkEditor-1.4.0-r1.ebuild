# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit eutils scons-utils toolchain-funcs multilib python-any-r1

DESCRIPTION="CLAM's visual builder"
HOMEPAGE="http://clam-project.org/"
SRC_URI="http://clam-project.org/download/src/${P}.tar.gz
http://ftp.debian.org/debian/pool/main/c/clam-networkeditor/clam-networkeditor_1.4.0-3.1.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libclam-1.4.0-r1
	<media-libs/libclam-9999
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtxmlpatterns
	dev-qt/qtopengl
	dev-qt/qtsvg
	virtual/glu"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

RESTRICT="mirror"

pkg_setup()	{
	tc-export CC CXX
	python-any-r1_pkg_setup
}

src_prepare() {
	# patches from debian for recent compilers
	EPATCH_SOURCE="${WORKDIR}"/debian/patches epatch \
		$(<"${WORKDIR}"/debian/patches/series)

	# patches created for gentoo
	epatch "${FILESDIR}"/${P}/*.patch
}

src_compile() {
	QTDIR="${EPREFIX}"/usr escons \
		clam_prefix="${EPREFIX}/usr" \
		prefix="${ED}/usr" \
		libdir=$(get_libdir) \
		qt_plugins_install_path="/$(get_libdir)/qt4/plugins/designer" \
		verbose=1

	# icons for desktop files, media-gfx/imagemagick is required for convert
	convert -resize 48x48 -colors 24 src/images/NetworkEditor-icon.png \
		clam-networkeditor.xpm || die
	convert -resize 48x48 -colors 24 src/images/Prototyper-icon.png \
		clam-prototyper.xpm || die
}

src_install() {
	QTDIR="${EPREFIX}"/usr escons libdir=$(get_libdir) install

	dodoc CHANGES README
	insinto /usr/share/pixmaps
	doins *.xpm
}
