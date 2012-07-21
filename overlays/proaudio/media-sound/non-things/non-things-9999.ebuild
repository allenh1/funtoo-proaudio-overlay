# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils git-2

DESCRIPTION="The Non Things: Non-DAW, Non-Mixer, Non-Sequencer and Non-Session-Manager"
HOMEPAGE="http://non.tuxfamily.org"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/daw.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="-debug non-daw non-mixer non-sequencer non-session-manager"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.103.0
	>=media-libs/liblrdf-0.1.0
	>=media-libs/liblo-0.26
	>=dev-libs/libsigc++-2.2.0
	>=x11-libs/fltk-1.1.7:1
	non-sequencer? ( media-sound/non-sequencer )"
DEPEND="${RDEPEND}"

# variables initialisation
daw=""
mixer=""
manager=""
if use non-daw
then
	daw="timeline"
fi
if use non-mixer
then
	mixer="mixer"
fi
if use non-session-manager
then
	manager="session-manager"
fi

pkg_setup() {
	if ! use non-daw ; then
		if ! use non-mixer ; then
			if ! use non-session-manager ; then
				eerror "You must set-up at least one of those 3 USE flags:"
				eerror ""
				eerror "USE=non-daw if you want the Digital Audio Workstation"
				eerror "USE=mon-mixer if you want the Digital Audio Mixer"
				eerror "USE=session-manager if you want the Non Session Manager"
				die
			fi
		fi
	fi
}

src_prepare() {
	# adding fltk cflags
	epatch "${FILESDIR}/non_makefile.patch"
	# removing of wrong and non needed path for Exec key of desktop files
	for i in ${daw} ${mixer} ${manager}
	do
		cd ${S}/$i
		sed -i -e 's;@BIN_PATH@:$(prefix)/bin;@BIN_PATH@/:;' makefile.inc || die "sed $i/makefile.inc failed"
	done
}

src_configure() {
	for i in nonlib FL ${daw} ${mixer} ${manager}
	do
		cd ${S}/$i
		local my_conf=""
		if use debug; then
			my_conf="--enable-debug"
		fi
		econf --prefix=/usr ${my_conf} || die "econf $i failed"
	done
}

src_compile() {
	for i in nonlib FL ${daw} ${mixer} ${manager}
	do
		cd ${S}/$i || die "cd ${S}/$i failed"
		make PREFIX=/usr || die "make $i failed"
	done
}

src_install() {
	mkdir -p ${D}/usr/bin
	for i in nonlib FL ${daw} ${mixer} ${manager}
	do
		cd ${S}/$i
		einstall || die "install $i failed"
	done
	if use non-daw ; then
		dobin "${S}/timeline/bin/import-external-sources"
		dobin "${S}/timeline/bin/remove-unused-sources"
	fi
}
