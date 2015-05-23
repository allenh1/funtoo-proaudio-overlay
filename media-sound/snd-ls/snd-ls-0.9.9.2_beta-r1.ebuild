# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils

RESTRICT=mirror
DESCRIPTION="Snd-ls is a sound editor based on Snd"
HOMEPAGE="http://www.notam02.no/arkiv/src/snd/"
SRC_URI="http://www.notam02.no/arkiv/src/snd/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-libs/rollendurchmesserzeitsammler
	>=dev-scheme/guile-1.8.0
	>=x11-libs/gtk+-2.0.0
	media-libs/liblrdf"

RDEPEND="${DEPEND}
	dev-libs/pcl
	sci-libs/gsl
	sci-libs/fftw
	media-sound/jack-audio-connection-kit
	media-libs/ladspa-sdk
	media-libs/libsamplerate
	>=media-libs/libsndfile-1
	=sci-libs/fftw-3*"

pkg_setup(){
	if ! built_with_use --missing true dev-scheme/guile deprecated; then
		eerror "You need to rebuild guile with"
		eerror "the 'deprecated' USE flag"
		eerror "USE=deprecated emerge dev-scheme/guile"
		die "dev-scheme/guile is not built with the 'deprecated' USE flag"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:\(define\ prefix\)\(.*\):\1 \"\'${D}'/usr/share\"):' config.scm
}

src_compile() {
#	Don't support portage's LDFLAGS
	LDFLAGS="" make || die "build failed"
}

src_install () {
	dodoc README
	dohtml -r snd-10/*.html snd-10/*.png
	rm -f snd-10/*.html snd-10/*.png snd-10/snd.1
	rm -rf snd-10/tutorial
	./do_install || die "installation failed"
	mv "${D}"/usr/share/bin/snd-ls "${S}"/
      	rm -rf ${D}/usr/share/bin
	sed -i -e 's:'${D}'::g' snd-ls
	sed -i -e 's:'${D}'::g' "${D}"/usr/share/snd-ls/init.scm
	dobin snd-ls
}

pkg_postinst() {
	ewarn ""
	ewarn "This version of Snd is very different from the"
	ewarn "one used in Dave Phillips Snd tutorial, so"
	ewarn "reading that one is not useful for this package."
	ewarn "Instead, look in the help menu of the program."
	ewarn ""
	ewarn "First time snd-ls is running, it will spend some time"
	ewarn "compiling. It will not use the same amount of time"
	ewarn "at next startup"
	ewarn ""
	ewarn "For a quick introduction to basic functions, select the"
	ewarn "first entry in the Help menu."
}
