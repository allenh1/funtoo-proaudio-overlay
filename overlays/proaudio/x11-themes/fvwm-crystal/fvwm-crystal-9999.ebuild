# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-crystal/fvwm-crystal-3.0.4.ebuild,v 1.6 2007/02/04 19:20:09 beandog Exp $

DESCRIPTION="Configurable and full featured theme for FVWM, with lots of transparency. This version add a freedesktop compatible menu"
HOMEPAGE="http://fvwm-crystal.sourceforge.net/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="laptop session"
RDEPEND=">=x11-wm/fvwm-2.5.13
	media-gfx/imagemagick
	|| ( >=x11-misc/stalonetray-0.6.2-r2 x11-misc/trayer )
	|| ( >=x11-misc/habak-0.2.4.1 x11-misc/hsetroot )
	sys-devel/bc
	!x11-themes/crystal-audio"

#S="${WORKDIR}/${PN}"
S="${WORKDIR}/current"

src_unpack() {
#	darcs get http://linux.net.pl/~harnir/fvwm-crystal/
	darcs get http://crystal-audio.sourceforge.net/repository/current
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

	einstall || die "einstall failed"

	dodoc AUTHORS COPYING README INSTALL NEWS ChangeLog doc/*
	cp -r addons ${D}/usr/share/doc/${PF}/

	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/fvwm-crystal

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
}

