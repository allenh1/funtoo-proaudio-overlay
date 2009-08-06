# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

At1="Minster1_000_WX_48k.wav"
At2="Minster1_000_YZ_48k.wav"
Ad="http://store.spatialaudiocreativeengineeringnetwork.com/"

IUSE=""

#inherit eutils multilib toolchain-funcs
RESTRICT="mirror fetch"

DESCRIPTION="Files used by Aeolus-ym to generate the convolution reverb using Ambiosonic impulse responses"
HOMEPAGE="http://space-net.org.uk/node/54"
SRC_URI="${At1}
	${At2}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=""

pkg_nofetch() {
	einfo "Download the 2 following files:"
	einfo "1: ${Ad}${At1}"
	einfo "2: ${Ad}${At2}"
	einfo "and move them to ${DISTDIR}"
	einfo ""
}

#src_unpack() {
	# nothing
#
#}

#src_compile() {
	# nothing
#}

#src_install() {
	# nothing
#}
