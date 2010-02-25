# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit subversion

DESCRIPTION="MIDI Arpeggiator w/ JACK Tempo Sync, includes Zonage MIDI splitter/manipulator"
HOMEPAGE="http://sourceforge.net/projects/arpage/"
SRC_URI=""
LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE=""
DEPEND=""
RDEPEND=""

ESVN_REPO_URI=https://arpage.svn.sourceforge.net/svnroot/arpage

src_compile() {
	cd "${WORKDIR}"/"${PN}"-9999/branches
	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	cd "${WORKDIR}"/"${PN}"-9999/branches
	emake -C src DESTDIR="${D}" install || die "stop"
}
