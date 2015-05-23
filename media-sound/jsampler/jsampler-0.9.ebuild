# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit java-pkg-2 java-ant-2 eutils

MY_P="${P/js/JS}"

DESCRIPTION="JSampler is a frontend for LinuxSampler written in Java"
HOMEPAGE="http://jsampler.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="classic sqlite"

RESTRICT="mirror"

RDEPEND="sqlite? ( media-sound/linuxsampler[sqlite] )
	!sqlite? ( media-sound/linuxsampler )
	>=virtual/jdk-1.6"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	if use classic; then
		eant build-jsclassic || die "eant failed"
	else
		eant build-fantasia || die "eant failed"
	fi
}

src_install() {
	local myjar="Fantasia-${PV}.jar"
	use classic && myjar="JS_Classic-${PV}.jar"

	java-pkg_dojar dist/${myjar}

	echo "#!/bin/sh" > ${PN}
	echo "cd /usr/share/${PN}" >> ${PN}
	echo "\${JAVA_HOME}/bin/java -jar \$(java-config -p jsampler) \$*" >> ${PN}

	dobin ${PN}

	newicon "res/fantasia/icons/app_icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "JSampler" "${PN}" "AudioVideo;Audio"

	dodoc README
}
