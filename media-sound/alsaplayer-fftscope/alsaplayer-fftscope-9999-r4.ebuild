# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76-r3.ebuild,v 1.6 2006/07/12 22:05:09 agriffis Exp $

EAPI="5"
inherit eutils git-2 autotools-utils

DESCRIPTION="FftScope external visualization scope for AlsaPlayer. It is a good starting point for others."
HOMEPAGE="http://www.alsaplayer.org/"
EGIT_REPO_URI="git://github.com/alsaplayer/alsaplayer.git"
EGIT_SOURCEDIR="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
DOCS=("AUTHORS" "ChangeLog" "README")

S="${WORKDIR}/${PN}/attic/fftscope"

DEPEND="media-sound/alsaplayer
	=dev-libs/glib-1.2*"

src_prepare() {
	./bootstrap || die "bootstrap failed"
}

src_configure() {
	autotools-utils_src_configure --disable-dependency-tracking
}
