# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils subversion

DESCRIPTION="liblscp is a C++ library for the Linux Sampler control protocol."
HOMEPAGE="http://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/liblscp/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND=""

src_prepare() {
	# upstream autoconf is broken at that time, use portage functions
	eautoreconf
	#make -f Makefile.svn
}
