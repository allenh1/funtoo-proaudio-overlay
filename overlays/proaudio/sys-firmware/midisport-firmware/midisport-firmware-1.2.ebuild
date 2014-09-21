# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

AUTOTOOLS_AUTORECONF="1"

inherit autotools-utils linux-info udev

DESCRIPTION="Firmware for M-Audio/Midiman USB MIDI devices"
HOMEPAGE="http://usb-midi-fw.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/usb-midi-fw/${P}.tar.gz"

LICENSE="Midisport"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-apps/fxload
	virtual/udev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD="1"
CONFIG_CHECK="~SND_USB_AUDIO"

PATCHES=(
	"${FILESDIR}/${P}-configure.patch"
	"${FILESDIR}/${P}-rules.patch"
)

src_configure() {
	local myeconfargs=( "--with-udev=$(get_udevdir)" )
	autotools-utils_src_configure
}
