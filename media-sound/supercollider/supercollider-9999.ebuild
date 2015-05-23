# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils eutils exteutils git-2 multilib versionator

DESCRIPTION="An environment and a programming language for real time audio synthesis."
HOMEPAGE="http://supercollider.sourceforge.net"
EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"
EGIT_HAS_SUBMODULES="1"

LICENSE="GPL-2 gpl3? ( GPL-3 )"
SLOT="0"
KEYWORDS=""

IUSE="+avahi coreaudio curl debug doc emacs +fftw gedit +gpl3 ide jack portaudio qt4 server +sndfile sse sse4 static-libs system-boost system-yaml test vim wiimote"
REQUIRED_USE="
	ide? ( qt4 )
	^^ ( coreaudio jack portaudio )"

# Both alsa and readline will be automatically checked in cmake but
# there are no options for theese. Thus the functionality cannot be
# controlled through USE flags. Therefore hard-enabled.
RDEPEND=">=media-sound/jack-audio-connection-kit-0.100.0
	media-libs/alsa-lib
	>=sys-libs/readline-5.0
	x11-libs/libXt
	avahi? ( net-dns/avahi )
	fftw? ( >=sci-libs/fftw-3.0 )
	portaudio? ( media-libs/portaudio )
	qt4? (
		>=dev-qt/qtcore-4.7
		>=dev-qt/qtwebkit-4.7
		ide? ( >=dev-qt/qtgui-4.7[gtkstyle] )
		!ide? ( >=dev-qt/qtgui-4.7 )
	)
	sndfile? ( >=media-libs/libsndfile-1.0.16 )
	system-boost? ( dev-libs/boost )
	system-yaml? ( dev-cpp/yaml-cpp )
	wiimote? ( app-misc/cwiid )"
DEPEND="${RDEPEND}
	dev-libs/icu
	virtual/pkgconfig
	emacs? ( virtual/emacs )
	gedit? ( app-editors/gedit )
	vim? ( app-editors/vim )"

DOCS=( AUTHORS README_LINUX.txt "${FILESDIR}/README.gentoo" )

pkg_pretend() {
	if use test; then
		ewarn "You are trying to install ${PN} with tests enabled. This will most"
		ewarn "probably fail. However, if it succeeds please let us know at"
		ewarn "proaudio@lists.tuxfamily.org. Please also do contact us if you know how"
		ewarn "to get the tests working."
	fi
}

src_prepare() {
	esed_check -i -e "s|SuperCollider|${PF}|" "${S}/platform/linux/CMakeLists.txt"
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE="Debug"
	local mycmakeargs=(
		$(cmake-utils_use_no avahi AVAHI)
		$(cmake-utils_use curl CURL)
		$(cmake-utils_use debug SC_MEMORY_DEBUGGING)
		$(cmake-utils_use debug SN_MEMORY_DEBUGGING)
		$(cmake-utils_use debug GC_SANITYCHECK)
		$(cmake-utils_use doc INSTALL_HELP)
		$(cmake-utils_use emacs SC_EL)
		$(cmake-utils_use !fftw FFT_GREEN)
		$(cmake-utils_use gedit SC_ED)
		$(cmake-utils_use_no gpl3 GPL3)
		$(cmake-utils_use ide SC_IDE)
		$(cmake-utils_use_no sndfile SNDFILE)
		$(cmake-utils_use qt4 SC_QT)
		$(cmake-utils_use server SCLANG_SERVER)
		$(cmake-utils_use sse SSE)
		$(cmake-utils_use sse4 SSE41)
		$(cmake-utils_use sse4 SSE42)
		$(cmake-utils_use !static-libs LIBSCSYNTH)
		$(cmake-utils_use system-boost SYSTEM_BOOST)
		$(cmake-utils_use system-yaml SYSTEM_YAMLCPP)
		$(cmake-utils_use test ENABLE_TESTSUITE)
		$(cmake-utils_use vim SC_VIM)
		$(cmake-utils_use wiimote SC_WII)
	)
	use coreaudio && mycmakeargs+=( "AUDIOAPI=coreaudio" )
	use jack && mycmakeargs+=( "AUDIOAPI=jack" )
	use portaudio && mycmakeargs+=( "AUDIOAPI=portaudio" )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# Do not violate multilib strict
	mv "${ED}/usr/lib" "${ED}/usr/$(get_libdir)" || die "mv failed"

	use emacs && newdoc editors/scel/README README.emacs
	use gedit && newdoc editors/sced/README README.gedit
	use vim && newdoc editors/scvim/README README.vim
}

pkg_postinst() {
	einfo
	einfo "Notice: SuperCollider is not very intuitive to get up and running."
	einfo "The best course of action to make sure that the installation was"
	einfo "successful and get you started with using SuperCollider is to take"
	einfo "a look through /usr/share/doc/${PF}/README.gentoo"
	einfo
}
