# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 eutils

DESCRIPTION="Advanced surround sound file editor"
HOMEPAGE="http://www.virtualworlds.de/AudioCutter/"
SRC_URI="mirror://sourceforge/audiocutter/${PN}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jre-1.5"
RDEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	sed -i -e 's|"../core/audiocutter/audiocutter"|"/usr/bin/audiocutter"|g' \
		gui/src/Platform.java
}

src_compile() {
	cd "${S}/core"
	econf || die "configure failed"
	sed -i -e 's|DEFS = -DHAVE_CONFIG_H|DEFS = -DHAVE_CONFIG_H -DLINUX|g' \
		audiocutter/Makefile
	
	emake || die "make failed"
	
	cd "${S}/gui"
	javac \
		-verbose \
		-encoding latin1 \
		-d classes \
		$(find . -name *.java) || die "javac failed"
	jar -cf ${PN}.jar \
		-C classes .
}

src_install() {
	# core
	cd core
	make DESTDIR="${D}" install || die "installing core failed"
	dodoc todo authors
	cd ..
	# gui
	java-pkg_dojar gui/${PN}.jar || die "dojar failed"
	# presets
	dodir /usr/share/${PN}/EFFECTS
	insinto /usr/share/${PN}/EFFECTS
	doins gui/effects/*.presets
	# fshapes
	dodir /usr/share/${PN}/FSHAPE
	insinto /usr/share/${PN}/FSHAPE
	doins gui/fshape/*.fshape
	# images
	dodir /usr/share/${PN}/images
	insinto /usr/share/${PN}/images
	doins gui/images/*

	# blah didn't not get this working...
	# failed to find the main class then
	#java-pkg_dolauncher ${PN} \
	#	-pre ${FILESDIR}/${PN}-pre \
	#	--pwd "\${HOME}/.AudioCutter" \

	newbin "${FILESDIR}/${PN}-pre" "${PN}"

	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry "${PN}" "AudioCutter Cinema" "${PN}" "AudioVideo;Audio"
}
