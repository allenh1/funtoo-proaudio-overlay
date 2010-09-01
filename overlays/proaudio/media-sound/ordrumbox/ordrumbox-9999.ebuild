# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2 java-ant-2 subversion

MY_P="${PN}-V${PV}"
MY_PV="0.9.03"

DESCRIPTION="The orDrumbox is a software drum machine, designed to a creative
pattern based way of drum programming with automatic music composition
capabilities."
HOMEPAGE="http://www.ordrumbox.com/"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.5
	dev-java/javatoolkit
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"

src_compile(){
	cd "${PN}Application"
	eant build || die "eant failed"
}

src_install() {
	java-pkg_dojar livraisons/${PN}-V${MY_PV}/${PN}-V${MY_PV}.jar
	# for whatever reason this one throws a null pointer exception
	java-pkg_dolauncher ${PN} --jar /usr/share/${PN}/lib/${PN}-V${MY_PV}.jar

	# so do it manually
	#echo "java -jar /usr/share/${PN}/lib/${MY_P}.jar" > ${S}/${PN}
	#dobin ${S}/${PN}

	#newicon src/skins/logo.png ${PN}.png
	make_desktop_entry ${PN} "orDrumbox" ${PN} "AudioVideo;Audio"
}
