# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit exteutils

MY_P=${P/_/-}

DESCRIPTION="a QT based Digital DJ tool"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="http://downloads.mixxx.org/${MY_P}/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug djconsole hifieq ladspa recording shout +vinylcontrol"

# TODO. It bundles libs, like samplerate, why?
RDEPEND="media-libs/mesa
	media-libs/libmad
	media-libs/libid3tag
	media-libs/libvorbis
	media-libs/libsndfile
	>=media-libs/portaudio-19_pre
	djconsole? ( media-libs/libdjconsole )
	shout? ( media-libs/libshout )
	ladspa? ( media-libs/ladspa-sdk )
	virtual/glu
	|| ( ( x11-libs/qt-core
		x11-libs/qt-gui
		x11-libs/qt-opengl )
		=x11-libs/qt-4.3*:4[opengl,qt3support] )"
DEPEND="${RDEPEND}
	dev-util/scons
	dev-util/pkgconfig"

S=${WORKDIR}/${P/_/\~}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:-O3::g' lib/cmetrics/SConscript || die "sed failed."
}

src_configure() {
	local myconf="optimize=0 ffmpeg=0 script=0 prefix=/usr \
		$(scons_use_enable djconsole) \
		$(scons_use_enable hifieq) \
		$(scons_use_enable debug) \
		$(scons_use_enable shout) \
		$(scons_use_enable ladspa) \
		$(scons_use_enable recording) \
		$(scons_use_enable vinylcontrol)"
	escons ${myconf} -c . || die "scons -c . failed."
}

src_compile() {
	escons ${myconf} || die "scons failed."
}

src_install() {
	dobin mixxx || die "dobin failed."

	insinto /usr/share/mixxx
	doins -r src/{skins,midi,keyboard} || die "doins failed."

	doicon src/mixxx-icon.png
	domenu src/mixxx.desktop

	dodoc HERCULES.txt README*

	insinto /usr/share/doc/${PF}
	doins Mixxx-Manual.pdf
}
