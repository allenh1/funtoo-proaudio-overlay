# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE: This ebuild depends on fox 1.7, even though I am unsure whether
#       this package will only build against the 1.7 slot.

EAPI="5"

[[ "${PV}" = "9999" ]] && inherit git-2

AUTOTOOLS_AUTORECONF="1"
inherit autotools-utils

if [[ "${PV}" = "9999" ]]; then
	EGIT_REPO_URI="git://github.com/signal11/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	# When 0.8.0 is officially available the following link should be
	# used.
	#SRC_URI="mirror://github/signal11/${PN}/${P}.zip"
	SRC_URI="http://public.callutheran.edu/~abarker/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${PN}
fi

RESTRICT="mirror"

DESCRIPTION="A multi-platform library for USB and Bluetooth HID-Class devices"
HOMEPAGE="http://www.signal11.us/oss/hidapi/"

LICENSE="BSD GPL-3"
SLOT="0"

IUSE="doc static-libs X"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	X? ( x11-libs/fox:1.7 )"

PATCHES=( "${FILESDIR}"/${PN}-fox17.patch )

src_configure() {
	local myeconfargs=( $(use_enable X testgui) )
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use doc; then
		doxygen doxygen/Doxyfile || die
	fi
}

src_install() {
	use doc && HTML_DOCS=( html/ )
	autotools-utils_src_install
}
