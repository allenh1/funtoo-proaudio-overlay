# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-crystal/fvwm-crystal-3.0.4.ebuild,v 1.6 2007/02/04 19:20:09 beandog Exp $

EAPI="2"
inherit subversion eutils python

PYTHON_DEPEND="2"

DESCRIPTION="Configurable and full featured FVWM theme, with lots of transparency and freedesktop compatible menu"
HOMEPAGE="http://fvwm-crystal.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="laptop session"

ESVN_REPO_URI="svn://svn.code.sf.net/p/fvwm-crystal/code"

# Should work with fvwm-2.5.13, but like portage use the correct fvwm exec name
# only from 2.5.26 and that I am using this version to develop fvwm-crystal, it
# is best to use 2.5.26 as dependency.
RDEPEND=">=x11-wm/fvwm-2.5.26[png]
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	|| ( >=x11-misc/stalonetray-0.6.2-r2 x11-misc/trayer )
	|| ( media-gfx/xloadimage x11-misc/hsetroot )
	sys-devel/bc
	!x11-themes/crystal-audio"

S="${WORKDIR}/${PN}"

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	sed -i 's/correctpermissions correctpath/correctpermissions/' Makefile || die "sed Makefile failed"

	if use session; then
		sed -i 's/Exec=fvwm/#Exec=fvwm/' addons/fvwm-crystal.desktop || die "sed failed"
		sed -i 's/#Exec=gnome/Exec=gnome/' addons/fvwm-crystal.desktop || die "sed failed"
	fi
	einfo "There is nothing to compile."
}

src_install() {
	#I added this USE flag because such recipes cause problem with rt-sources
	# when the appropriate support is not compiled into the kernel
	if ! use laptop; then
		rm -f fvwm/recipes/*ACPI
	fi

	emake DESTDIR="${D}" prefix="/usr" install || die install failed

	dodoc AUTHORS README INSTALL NEWS ChangeLog doc/*
	cp -r addons "${D}"/usr/share/doc/"${PF}"/

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/fvwm-crystal

	insinto /usr/share/xsessions
	doins addons/fvwm-crystal.desktop
}

pkg_postinst() {
	einfo
	einfo "After installation, execute following commands:"
	einfo " $ cp -r /usr/share/doc/${PF}/addons/Xresources ~/.Xresources"
	einfo " $ cp -r /usr/share/doc/${PF}/addons/Xsession ~/.xinitrc"
	einfo
	einfo "Many applications can extend functionality of fvwm-crystal."
	einfo "They are listed in /usr/share/doc/${PF}/INSTALL.gz."
	einfo
	einfo "If you want gnome-session support if FVWM-Crystal, please"
	einfo "emerge this program with USE=session."
	einfo "Read addons/session-management.README, it contain important"
	einfo "information about session management support in FVWM-Crystal"
	einfo
	einfo "Some icons fixes was committed recently to the svn"
	einfo "To archive the same fixes on your private icon files,"
	einfo "please read /usr/share/doc/${PF}/INSTALL.gz."
	einfo "This will fix the libpng warnings at stderr."
	einfo
}
