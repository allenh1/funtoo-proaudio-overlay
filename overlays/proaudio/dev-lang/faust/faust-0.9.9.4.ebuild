# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

IUSE="doc"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="Faust AUdio STreams is a functional programming language for realtime audio plugins and applications development. The Faust compiler translates signal processing specifications into C++ code."
HOMEPAGE="http://faudiostream.sourceforge.net"
SRC_URI="mirror://sourceforge/faudiostream/${P}b.tar.gz"

RDEPEND="sys-devel/bison
		 sys-devel/flex"
DEPEND="sys-apps/sed"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	# missing destdir
	esed_check -i -e 's@\($(prefix)\)@$(DESTDIR)/\1@g' Makefile
	esed_check -i -e 's@mkdir -p \($(DESTDIR).*\)@install -d \1@g' Makefile
	# create dir for binary
	esed_check -i -e 's@^\(install :.*\)@\1\n\tinstall -d $(DESTDIR)/$(prefix)/bin@g' Makefile
	# fix prefix
	esed_check -i -e "s\/usr/local\ /usr\ " Makefile
}

src_compile() {
	emake || die "parallel make failed"
}

src_install() {
	make install DESTDIR="${D}"
	dodoc README 
	insinto /usr/share/doc/"${P}"
	use doc doins faust_tutorial.pdf
}
