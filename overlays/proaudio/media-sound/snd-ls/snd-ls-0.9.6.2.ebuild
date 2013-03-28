# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

#inherit multilib

RESTRICT=mirror
DESCRIPTION="Snd is a sound editor"
HOMEPAGE="http://ccrma.stanford.edu/~kjetil/"
SRC_URI="http://ccrma.stanford.edu/~kjetil/src/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=dev-scheme/guile-1.6.7
	>=x11-libs/gtk+-2.0.0
	media-libs/liblrdf"

RDEPEND="${DEPEND}
	sci-libs/fftw
	media-sound/jack-audio-connection-kit
	media-libs/ladspa-sdk
	media-libs/libsamplerate
	=sci-libs/fftw-3*"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:\(define\ prefix\)\(.*\):\1 \"\'${D}'/usr/share\"):' config.scm
}

src_compile() {
	./build || die "build failed"
}

src_install () {
	# generate new-launcher-script
	gen_script(){
		cat << EOT > "${S}"/snd-ls
#!/bin/sh
export LD_LIBRARY_PATH=/usr/lib:\$LD_LIBRARY_PATH
/usr/share/snd-ls/snd-8/snd -noglob -noinit -l /usr/share/snd-ls/init.scm \$@
EOT
	}
	dodoc README
	dohtml -r snd-8/*.html snd-8/*.png snd-8/tutorial
	rm -f snd-8/*.html snd-8/*.png snd-8/snd.1
	rm -rf snd-8/tutorial
	./install || die "installation failed"
	sed -i -e 's:'${D}'::g' "${D}"/usr/share/snd-ls/init.scm
	# try to mv and patch the loader-script it it not exists generate new
	if [ -e "${D}/usr/share/bin/snd-ls" ];then
		mv "${D}/usr/share/bin/snd-ls" "${S}/snd-ls"
		sed -i -e 's:'${D}'::g' "${S}/snd-ls" || gen_script
	else
		gen_script
	fi
	rm -rf "${D}"/usr/share/bin
	dobin snd-ls
}

pkg_postinst() {
	ewarn ""
	ewarn "This is an experimental ebuild."
	ewarn "Snd-ls is configured to use jack and/or alsa."
	ewarn ""
	ewarn "You will find Dave Philips Snd tutorial"
	ewarn " in /usr/share/doc/snd-ls-0.9.6.2/html/tutorial/"
	ewarn ""
}
