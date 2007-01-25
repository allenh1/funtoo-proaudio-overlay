# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs eutils

DESCRIPTION="QSampler is a graphical frontend to the LinuxSampler engine."
HOMEPAGE="http://www.linuxsampler.org/"
#SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.gz"

ECVS_SERVER="cvs.linuxsampler.org:/var/cvs/linuxsampler"
ECVS_MODULE="qsampler"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="=x11-libs/qt-3*
	>=media-libs/liblscp-9999
	>=media-libs/libgig-9999
	>=media-sound/linuxsampler-9999
	!media-sound/qsampler-cvs
	media-libs/alsa-lib"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${ECVS_MODULE}

src_unpack() {
	cvs_src_unpack
cd ${S}
}

src_compile() {
	make -f Makefile.cvs
	econf || die "./configure failed"


	### borrowed from kde.eclass #
	#
	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox,
	# so that the build process can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"

	emake || die "make failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README
} 
