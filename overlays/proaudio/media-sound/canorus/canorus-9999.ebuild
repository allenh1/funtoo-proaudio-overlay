# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
CMAKE_IN_SOURCE_BUILD="1"

inherit eutils qt4-r2 subversion cmake-utils

ESVN_REPO_URI="svn://svn.berlios.de/canorus/trunk"
ESVN_PROJECT="canorus"

DESCRIPTION="a free extensible music score editor"
HOMEPAGE="http://canorus.berlios.de"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="doc -python -ruby userdoc"

RDEPEND="python? ( >=dev-lang/python-2.5 )
	sys-libs/zlib
	media-libs/alsa-lib
	>=dev-qt/qtsvg-4.4:4
	>=dev-qt/qtcore-4.4:4
	ruby? ( dev-lang/ruby )
	sys-libs/libunwind
	media-sound/lilypond
	dev-qt/qthelp:4"

DEPEND="${REDEND}
	dev-lang/swig
	userdoc? ( app-office/lyx
		dev-tex/tex4ht )
	doc? ( app-doc/doxygen )"

pkg_setup() {
	ewarn "USE=python will fail to compile with recent versions of swig."
	ewarn "USE=ruby work but do nothing. If you know how to fix it,"
	ewarn "please considere to contribute."

	mycmakeargs+=" -DCANORUS_INSTALL_LIB_DIR=$(get_libdir) \
		-DNO_PYTHON=$( use python && echo false || echo true ) \
		-DNO_RUBY=$( use ruby && echo false || echo true )"
}

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-MAKE_DIRECTORY.patch"
	epatch "${FILESDIR}/0001-Remove-extra-documentation.patch"
	epatch "${FILESDIR}/0003-Reduce-linked-libraries.patch"
	epatch "${FILESDIR}/0006-Add-lz-and-lpthread-to-linker-flags.patch"
	epatch "${FILESDIR}/0008-Do-not-install-examples.patch"
	epatch "${FILESDIR}/${PN}-desktop_file.patch"
	if use userdoc ; then
		sed -i -e "s/htlatex/mk4ht htlatex/g" "${S}"/doc/usersguide/Makefile \
		|| die "sed userdoc Makefile failed"
	fi
}

src_compile() {
	cmake-utils_src_compile || die "make failed"
	if use userdoc ; then
		cd doc/usersguide
		make qthelp || die "make users documentation failed"
	fi
	if use doc ; then
		cd "${S}"/doc/developersguide
		make || die "make developpers guide failed"
	fi
}

src_install() {
	dodoc AUTHORS DEVELOPERS NEWS README TODO VERSION
	# install the examples
	insinto /usr/share/doc/"${P}"/examples
	doins examples/* || die "install examples failed"
	insinto /usr/share/doc/"${P}"/examples/midi
	doins examples/midi/* || die "install examples/midi failed"
	insinto /usr/share/doc/"${P}"/examples/musicxml
	doins examples/musicxml/* || die "install examples/musicxml failed"
	# install a desktop file with its icon
	domenu canorus.desktop
	insinto /usr/share/icons
	newins doc/usersguide/images/canorushelpicon.png canorus.png
	# install the user documentation
	if use userdoc ; then
		insinto "/usr/share/${PN}/doc/usersguide"
		doins doc/usersguide/*.qhc
		doins doc/usersguide/*.qch
	fi
	# install the debeloppers documentation
	if use doc ; then
		dohtml doc/developersguide/html/* || die "install developpers doc failed"
	fi

	qt4-r2_src_install || die "install failed"
}
