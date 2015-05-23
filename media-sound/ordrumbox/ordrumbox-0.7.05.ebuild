# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

MY_P="${PN}-V${PV}"

DESCRIPTION="The orDrumbox is a software drum machine, designed to a creative
pattern based way of drum programming with automatic music composition
capabilities."
HOMEPAGE="http://www.ordrumbox.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"

src_compile() {
	eant dist || die "eant failed"
}

src_install() {
	java-pkg_dojar livraisons/${MY_P}/${MY_P}.jar
	# for whatever reason this one throws a null pointer exception
	java-pkg_dolauncher ${PN} --jar /usr/share/${PN}/lib/${MY_P}.jar

	# so do it manually
	#echo "java -jar /usr/share/${PN}/lib/${MY_P}.jar" > ${S}/${PN}
	#dobin ${S}/${PN}

	newicon src/skins/logo.png ${PN}.png
	make_desktop_entry ${PN} "orDrumbox" ${PN} "AudioVideo;Audio"
}
