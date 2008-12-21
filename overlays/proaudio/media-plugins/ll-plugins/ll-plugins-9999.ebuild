# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib git

DESCRIPTION="collection of LV2 plugins, LV2 extension definitions, and LV2 related tools"
HOMEPAGE="http://ll-plugins.nongnu.org"

EGIT_REPO_URI="git://git.sv.gnu.org/ll-plugins.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.109.0
	>=dev-cpp/gtkmm-2.8.8
	>=dev-cpp/cairomm-0.6.0
	>=media-sound/lash-0.5.1
	>=media-libs/liblo-0.22
	>=sci-libs/gsl-1.8
	>=media-libs/libsndfile-1.0.16
	dev-util/lv2-c++-tools"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	git_src_unpack
	cd "${S}"
	# ar doesn't really like ldflags
	sed -e 's:ar rcs $$@ $$^ $(LDFLAGS) $$($(2)_LDFLAGS):ar rcs	$$@ $$^:' \
		-i Makefile.template || die
}

src_compile(){
	./configure \
		--prefix=/usr \
		--CFLAGS="${CFLAGS} `pkg-config --cflags slv2`" \
		--LDFLAGS="${LDFLAGS} `pkg-config --libs slv2`" \
		|| die "configure failed"
	emake || die "make failed"
}

src_install(){
	make DESTDIR="${D}" libdir="/usr/$(get_libdir)" install || die "install failed"
}
