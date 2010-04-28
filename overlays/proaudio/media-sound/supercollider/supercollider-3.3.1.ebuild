# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit elisp-common toolchain-funcs

DESCRIPTION="An environment and a programming language for real time audio synthesis."
HOMEPAGE="http://www.audiosynth.com http://supercollider.sourceforge.net"

MY_PN="SuperCollider"
MY_P="${MY_PN}-${PV}"

SRC_URI="mirror://sourceforge/${PN}/Source/${PV}/${MY_P}-Source-linux.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

# lid means linux input device support.
IUSE="alsa debug devel emacs lid sse wii"
#IUSE="alsa debug devel emacs gedit lid sse vim wii"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100.0
	media-libs/alsa-lib
	>=media-libs/libsndfile-1.0.16
	>=sci-libs/fftw-3.0"
	#>=sys-libs/readline-5.0

DEPEND="${RDEPEND}
	sys-apps/sed
	sys-devel/automake
	dev-util/scons
	emacs? ( virtual/emacs )
	dev-util/pkgconfig
	dev-util/scons"
#	gedit? ( app-editors/gedit )
#	vim? ( app-editors/vim )

S="${WORKDIR}/${MY_PN}-Source"

src_prepare() {
	# Uncommenting a line per linux/examples/sclang.cfg.in
	if ! use emacs; then
		sed -ie "/#-@SC_LIB_DIR@\/Common\/GUI\/Document.sc/s/^#//" \
			"${S}/linux/examples/sclang.cfg.in" ||
			die "sed failed."
	else
		sed -e "/elisp_dir = os.path.join(INSTALL_PREFIX/s/site-lisp')/site-lisp','scel')/" \
		-i "${S}/SConstruct" ||
		die "modifying elisp installdir failed."
	fi

	# remove strange rpath
	sed -e "/LINKFLAGS = /s/'-Wl,-rpath,build -Wl/'-Wl/" -i "${S}/SConstruct" ||
		die "fix rpath failed."
}

src_compile() {
	myconf=""
	! use alsa; myconf="${myconf} ALSA=$?"
	! use debug; myconf="${myconf} DEBUG=$?"
	! use devel; myconf="${myconf} DEVELOPMENT=$?"
#	! use gedit; myconf="${myconf} SCED=$?"
	! use emacs; myconf="${myconf} SCEL=$?"
	! use lid;  myconf="${myconf} LID=$?"
	! use sse; myconf="${myconf} SSE=$?"
#	! use vim; myconf="${myconf} SCVIM=$?"
	! use wii; myconf="${myconf} WII=$?"
#	if use sse ;then
#		myconf="${myconf} SSE=yes \
#			CUSTOMCCFLAGS=-I$(dirname $(gcc-config -X)) \
#			CUSTOMCXXFLAGS=-I$(dirname $(gcc-config -X))"
#	fi
#	if use pentium4 ;then
#		myconf="${myconf} OPT_ARCH=pentium4"
#	fi

	myconf="${myconf} CROSSCOMPILE="1" READLINE="0""
	myconf="${myconf} AUDIOAPI="jack""

	tc-export CC CXX
	myconf="${myconf} CC="${CC}" CXX="${CXX}""

	mkdir -p "${D}"
	einfo "${myconf}"
	#CCFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
	scons CUSTOMCCFLAGS="${CFLAGS}" CUSTOMCXXFLAGS="${CXXFLAGS}" \
		PREFIX="/usr" DESTDIR="${D}" \
	 	${myconf} || die "scons failed."
}

src_install() {
	# Main install
	scons  install

	# Install our config file
	insinto /etc/supercollider
	doins linux/examples/sclang.cfg

	# Documentation
	mv "README LINUX" "README-linux"
	mv editors/scel/README editors/scel/README-scel
	dodoc README-linux editors/scel/README-scel

	# Our documentation
	sed -e "s:@DOCBASE@:/usr/share/doc/${PF}:" < "${FILESDIR}/README-gentoo.txt" | gzip > "${D}/usr/share/doc/${PF}/README-gentoo.txt.gz"

	# Example files (don't gzip)
	insinto /usr/share/doc/${PF}/examples
	doins linux/examples/onetwoonetwo.sc linux/examples/sclang.sc

	use emacs && elisp-site-file-install "${FILESDIR}/70scel-gentoo.el"
}

pkg_postinst() {
	einfo
	einfo "Notice: SuperCollider is not very intuitive to get up and running."
	einfo "The best course of action to make sure that the installation was"
	einfo "successful and get you started with using SuperCollider is to take"
	einfo "a look through /usr/share/doc/${PF}/README-gentoo.txt.gz"
	einfo
}
