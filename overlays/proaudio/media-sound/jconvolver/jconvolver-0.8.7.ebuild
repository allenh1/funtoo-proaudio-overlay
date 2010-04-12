# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="examples"

inherit exteutils multilib toolchain-funcs
RESTRICT="mirror"

DESCRIPTION="Command line convolution reverb by Fons Adriaensen"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/index.html"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2
	examples? ( http://www.kokkinizita.net/linuxaudio/downloads/${PN}-reverbs.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="|| ( x11-libs/libX11 virtual/x11 )
	>=media-libs/libclthreads-2.4.0
        >=media-libs/zita-convolver-0.1.0
        >=media-libs/libsndfile-1.0.17
	=sci-libs/fftw-3*"

S="${S}/source"
EX_S="${WORKDIR}/reverbs"
src_unpack() {
	unpack ${A}
	cd "${S}"
	echo $S
	# fixup the Makefile (installation and prefix)
	esed_check -i -e 's@^\(install:.*\)@\1\n\t/usr/bin/install -d $(DESTDIR)/$(PREFIX)/bin@g' \
		-e 's@\(/usr/bin/install -m 755.*\$\)@\1(DESTDIR)/$@g' \
		-e 's@^PREFIX.*@PREFIX = /usr@g' Makefile
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	if use examples; then
		insinto /usr/share/doc/${P}/examples/reverbs
		doins ${EX_S}/*
		insinto /usr/share/doc/${P}/examples/reverbs/sala-concerti-cdm
		doins ${EX_S}/sala-concerti-cdm/*
		insinto /usr/share/doc/${P}/examples/reverbs/santa-elisabetta
		doins ${EX_S}/santa-elisabetta/*
		fi
}
