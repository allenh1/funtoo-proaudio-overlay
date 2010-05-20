# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit git eutils

DESCRIPTION="The Non DAW is a powerful, reliable and fast modular Digital Audio Workstation system"
HOMEPAGE="http://non-daw.tuxfamily.org/"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/daw.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc"

DEPEND=">=x11-libs/fltk-1.1.8:1.1
	>=media-libs/liblrdf-0.4.0
	>=media-libs/libsndfile-0.18.0
	>=media-sound/jack-audio-connection-kit-0.103"
RDEPEND="${DEPEND}"

src_compile() {
	local x
	local debugme
	# the components of non-daw
	local ndc="nonlib FL timeline mixer"

	# patches for sandbox install violations
	epatch "${FILESDIR}/${P}-Makefiles.patch"

	# don't strip the binaries
	sed -i -e '/strip/d' "${S}/timeline/Makefile" "${S}/mixer/Makefile" \
		|| die "sed strip fix failed"

	# needs CFLAGS/CXXFLAGS work. yes, it is ugly.
	if use debug ; then
		debugme=yes
		sed -i -e "/^[[:blank:]]CFLAGS/ s/-pipe//" \
			-e "/^[[:blank:]]CFLAGS/ s/-O0/${CFLAGS}/" \
			-e "/^[[:blank:]]CXXFLAGS/ \
			s/\= -Wnon-virtual-dtor/\= ${CXXFLAGS} -Wnon-virtual-dtor/" \
			"${S}/timeline/Makefile" "${S}/mixer/Makefile" \
			"${S}/FL/Makefile" "${S}/nonlib/Makefile" \
			|| die "sed CFLAGS/CXXFLAGS for debug failed"
	else
		debugme=no
		sed -i -e "/^[[:blank:]]CFLAGS/ s/-pipe -O2/${CFLAGS}/" -e \
			"/^[[:blank:]]CXXFLAGS/ s/\= -fno-rtti/\= ${CXXFLAGS} -fno-rtti/" \
			"${S}/timeline/Makefile" "${S}/mixer/Makefile" \
			"${S}/FL/Makefile" "${S}/nonlib/Makefile" \
			|| die "sed CFLAGS/CXXFLAGS for non debug failed"
	fi

	# configure all components
	for x in ${ndc} ; do
		pushd "${x}" || die "pushd ${x} failed"
		case "${x}" in
			nonlib|FL)
			# the configure scripts are hand written. at least one option is
			# needed or they will prompt for input from stdin and pause the
			# emerge. thus we force debug and provide our own flags with the
			# sed mess above
				./configure --enable-debug="${debugme}" \
					|| die "configure ${x} failed"
			;;
			timeline|mixer)
			# only the timeline and mixer components have install scripts
				./configure --prefix=/usr --enable-debug="${debugme}" \
					|| die "configure ${x} failed"
			;;
			*) die "no ${x} found" ;;
		esac
		popd
	done

	# compile all components
	for x in ${ndc} ; do
		pushd "${x}" || die "pushd ${x} failed"
		emake || die "emake ${x} failed"
		popd
	done
}

src_install() {
	# only the timeline and mixer components have install scripts
	local x
	for x in timeline mixer ; do
		pushd "${x}" || die "pushd ${x} failed"
		make DESTDIR="${D}" install || die "make install of ${x} failed"
		popd
	done

	# shell script tools
	dobin "${S}/timeline/bin/import-external-sources"
	dobin "${S}/timeline/bin/remove-unused-sources"

	# docs install
	mv "${D}/usr/share/doc/" "${T}"
	if use doc ; then
		cd "${T}/doc"
		dohtml -r non-daw
		dohtml -r non-mixer
		# maybe moving docs breaks "Manual" entry in Help menu but it doesn't
		# appear to function anyway
		#cd "${D}/usr/share/doc"
		#dosym "${P}/html/non-daw"
		#dosym "${P}/html/non-mixer"
	fi
}
