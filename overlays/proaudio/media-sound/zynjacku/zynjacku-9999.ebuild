# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git autotools

DESCRIPTION="JACK based, GTK (2.x) host for LV2 synths"
HOMEPAGE="http://home.gna.org/zynjacku/"

EGIT_REPO_URI="git://repo.or.cz/zynjacku.git"
ESVN_PROJECT="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE="+lv2dynparam"
DEPEND=">=media-sound/jack-audio-connection-kit-0.109.0
	>=media-libs/lv2core-1
	>=dev-python/pygtk-2.0
    >=dev-python/pycairo-1.8.2
    lv2dynparam? ( =media-libs/lv2dynparam1-9999 )"

RDEPEND"${DEPEND}"

pkg_setup() {
	ewarn "if building fails try the following:"
	ewarn "emerge -O =media-libs/lv2dynparam1-9999"
}

src_unpack() {
	git_src_unpack
	cd "${S}"
	chmod +x gen_py_constants.py
	./bootstrap
}

src_compile() {
	econf || die "Configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	insinto /usr/lib/zynjacku
	doins zynjacku.so zynjacku.py zynjacku.glade
	fperms +x /usr/lib/zynjacku/zynjacku.py
	dosym /usr/share/zynjacku/gpl.txt /usr/lib/zynjacku/gpl.txt
	dosym /usr/bin/midi_led.py /usr/lib/zynjacku/midi_led.py
	make_wrapper "zynjacku" "/usr/lib/zynjacku/zynjacku.py" "/usr/lib/zynjacku"
}

pkg_postinst() {
	elog "to lauch eg. zynadd type:"
	elog "zynjacku http://home.gna.org/zyn/zynadd/0"
}
