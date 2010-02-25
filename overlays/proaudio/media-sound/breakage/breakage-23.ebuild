# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""

DESCRIPTION="Intelligent drum machine."
HOMEPAGE="http://www.blackholeprojector.com/index.html"
MY_P="${P/b/B}"
MY_PN="${PN/b/B}"
HOMEPAGE="http://ollieglass.com/breakage/index.html"
SRC_URI="http://ollieglass.com/breakage/download/${MY_P}.zip"

RESTRICT="mirror"
LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"

INSTALLDIR="/opt/${PN}"
S="${WORKDIR}/${MY_PN}"

DEPEND="media-sound/chuck
	app-arch/unzip
	media-sound/jack-audio-connection-kit
	|| ( virtual/jre virtual/jdk )"

src_install() {
	# Breakage-23 ships with chuck binary (contrary to the earlier versions),
	# which didn't work for me, so lets remove it and use the one in portage.
	# Anyway, it saves disk-space :)
	rm -f chuck
	dosym `which chuck` ${INSTALLDIR}/

	# Lets remove the stupid OS X-derived dotfiles, too!
	find ${S} -depth -type f -name ".DS_Store" -exec rm -rf {} \;

	insinto ${INSTALLDIR}
	doins -r *
	#dobin ${FILESDIR}/breakage

	# Write-permissions for 'audio'-group. (Breakage is not really meant
	# to be installed system-wide.)
	chown -R root:audio ${D}/${INSTALLDIR}/projects
	chmod -R 0775 ${D}/${INSTALLDIR}/projects
	make_wrapper breakage "java -jar Breakage2.jar" /opt/breakage/
}

pkg_postinst() {
	einfo
	einfo "Please make sure that your user belongs to the"
	einfo "'audio'-group, otherwise you cannot save anything"
	einfo "from Breakage!"
	ewarn "This ebuild is experimental!"
	einfo
}
