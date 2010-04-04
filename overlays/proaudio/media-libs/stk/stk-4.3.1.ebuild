# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Synthesis ToolKit in C++"
HOMEPAGE="http://ccrma.stanford.edu/software/stk/"
SRC_URI="http://ccrma.stanford.edu/software/stk/release/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa debug doc examples jack oss"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-cflags-lib.patch"
	epatch "${FILESDIR}/${P}-gcc43.patch"
	epatch "${FILESDIR}/${P}-fpic.patch"
	epatch "${FILESDIR}/${P}-missing.patch"
	epatch "${FILESDIR}/${P}-ldflags.patch"
	epatch "${FILESDIR}/${P}-gcc44.patch"
	eautoreconf
}

src_compile() {
	econf \
		`use_with alsa` \
		`use_with jack` \
		`use_with oss` \
		`use_enable debug` \
		RAWWAVE_PATH=/usr/share/stk/rawwaves/ \
		|| die "configure failed!"

	# compile libstk
	cd src
	emake || die "make in src failed!"

	# compile examples and projects
	if use examples; then
		cd ../projects
		for i in demo effects examples ragamatic; do
			einfo "Compiling $i ..."
			cd $i
			emake || die
			rm -f Release/*.o
			cd ..
		done
	fi
}

src_install() {
	dodoc README
	# install the lib
	dolib src/libstk.*
	# install headers
	insinto /usr/include/stk
	doins include/*.h include/*.msg include/*.tbl
	# install rawwaves
	insinto /usr/share/stk/rawwaves
	doins rawwaves/*.raw
	# install examples
	if use examples; then
		# cleanup
		for i in *.bat *.cpp *.h *Makefile* *.tcl *.dsp *.dsw; do
			find projects/ -name $i -exec rm -f {} \;
		done
		rm -r projects/*/{Debug,Release,tcl}
		# demo
		exeinto /usr/libexec/"${PN}"/demo
		for i in demo Drums Md2Skini Modal Physical Shakers StkDemo Voice; do
			doexe projects/demo/$i
		done
		insinto /usr/share/"${PN}"/demo
		doins -r projects/demo/scores
		# examples
		exeinto /usr/libexec/"${PN}"/examples
		doexe projects/examples/*
		insinto /usr/share/"${PN}"/examples
		doins -r projects/examples/{rawwaves,midifiles,scores}
		# effects
		exeinto /usr/libexec/"${PN}"/effects
		doexe projects/effects/effects projects/effects/StkEffects
		# ragamatic
		exeinto /usr/libexec/"${PN}"/ragamatic
		doexe projects/ragamatic/Raga projects/ragamatic/ragamat
		insinto /usr/share/"${PN}"/ragamatic
		doins -r projects/ragamatic/rawwaves
	fi
	# install docs
	if use doc; then
		dohtml -r doc/html/*
	fi
}

pkg_postinst() {
	if use examples; then
		elog "The binaries for the examples have been installed to"
		elog "/usr/libexec/${PN}, the scores, rawwaves and midifiles"
		elog "are in /usr/share/${PN}."
	fi
}
