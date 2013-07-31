# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# == THIS IS WORK IN PROGRESS ==
# [TODO]
# * sys-apps/dbus should be sys-apps/dbus[${MULTILIB_USEDEP}] when dbus
#   has been migrated to mulilib eclasses.
# * When libffado has been migrated to multilib eclasses
#   media-libs/libffado should be
#   media-libs/libffado[${MULTILIB_USEDEP}]
# [NOTE]
# The mixed features in the build system are not used. We let the
# multilib eclasses do all the work.

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit eutils git-2 python-single-r1 waf-utils multilib-minimal

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://jackaudio.org/"

EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug doc dbus ieee1394 opus pam"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Remove when multilib dbus is available.
REQUIRED_USE="${REQUIRED_USE} amd64? ( abi_x86_32? ( !dbus ) )"

# Remove when multilib libffado is available.
REQUIRED_USE="${REQUIRED_USE} amd64? ( abi_x86_32? ( !ieee1394 ) )"

RDEPEND="media-libs/libsamplerate[${MULTILIB_USEDEP}]
	>=media-libs/libsndfile-1.0.0[${MULTILIB_USEDEP}]
	${PYTHON_DEPS}
	alsa? ( >=media-libs/alsa-lib-1.0.24[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus )
	ieee1394? ( media-libs/libffado )
	opus? ( media-libs/opus[custom-modes,${MULTILIB_USEDEP}] )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r7
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	dbus? ( dev-python/dbus-python )
	pam? ( sys-auth/realtime-base )"

DOCS=( ChangeLog README README_NETJACK2 TODO )

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	local mywafconfargs=(
		$(usex alsa --alsa "")
		$(usex dbus --dbus --classic)
		$(usex debug --debug "")
		$(usex ieee1394 --firewire "")
	)

	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_configure \
		${mywafconfargs[@]}
}

multilib_src_compile() {
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_compile

	if multilib_is_native_abi && use doc; then
		doxygen || die "doxygen failed"
	fi
}

multilib_src_install() {
	multilib_is_native_abi && use doc && HTML_DOCS=( "${BUILD_DIR}"/html/ )
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_install
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
}
