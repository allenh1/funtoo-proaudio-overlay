# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit subversion eutils python-r1

DESCRIPTION="Configurable and full featured FVWM theme, with lots of transparency and freedesktop compatible menu"
HOMEPAGE="http://fvwm-crystal.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

ESVN_REPO_URI="svn://svn.code.sf.net/p/fvwm-crystal/code"

RDEPEND="${PYTHON_DEPS}
	>=x11-wm/fvwm-2.5.26[png]
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	|| ( >=x11-misc/stalonetray-0.6.2-r2 x11-misc/trayer )
	|| ( x11-misc/hsetroot media-gfx/feh )
	sys-apps/sed
	sys-devel/bc
	virtual/awk
	x11-apps/xwd
	!x11-themes/crystal-audio
	!x11-misc/habak"

S="${WORKDIR}/${PN}"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-build.patch

	epatch_user
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}" \
		prefix="/usr" \
		install

#	python_replicate_script \
#		"${D}/usr/bin/${PN}".{apps,wallpaper} \
#		"${D}/usr/share/${PN}"/fvwm/scripts/FvwmMPD/*.py
}

pkg_postinst() {
	einfo
	einfo "After installation, execute following commands:"
	einfo " $ cp -r ${EPREFIX}/usr/share/${PN}/addons/Xresources ~/.Xresources"
	einfo " $ cp -r ${EPREFIX}/usr/share/${PN}/addons/Xsession ~/.xinitrc"
	einfo
	einfo "Many applications can extend functionality of fvwm-crystal."
	einfo "They are listed in ${EPREFIX}/usr/share/doc/${PF}/INSTALL.gz."
	einfo
	einfo "Some icons fixes was committed recently to the svn"
	einfo "To archive the same fixes on your private icon files,"
	einfo "please read ${EPREFIX}/usr/share/doc/${PF}/INSTALL.gz."
	einfo "This will fix the libpng warnings at stderr."
	einfo
	einfo "The color themes was updated to Fvwm InfoStore."
	einfo "To know how to update your custom color themes, please run"
	einfo "	${EPREFIX}/usr/share/${PN}/addons/convert_colorsets."
	einfo ""
}
