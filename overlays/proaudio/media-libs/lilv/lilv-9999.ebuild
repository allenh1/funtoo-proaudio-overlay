# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit waf-utils subversion

DESCRIPTION="A library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"
ESVN_UP_FREQ="1"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bash-completion debug doc jack swig"

RDEPEND=">=dev-libs/glib-2.26.1-r1:2
	( || ( >=media-libs/lv2core-6 >=media-libs/lv2-1.0.0 ) )
	>=dev-libs/serd-0.5
	>=dev-libs/sord-0.5
	jack? ( >=media-sound/jack-audio-connection-kit-0.120.1 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	swig? ( dev-lang/swig )
	dev-lang/python
	dev-util/pkgconfig"

src_prepare() {
	# work around ldconfig call causing sandbox violation
	sed -i -e "s/bld.add_post_fun(autowaf.run_ldconfig)//" ${PN}/wscript || die
}

src_configure() {
	cd "${PN}"
	tc-export CC CXX CPP AR RANLIB
	waf-utils_src_configure --mandir="/usr/share/man" \
		$(use bash-completion || echo "--no-bash-completion") \
		$(use doc && echo "--docs") \
		$(use debug && echo "--debug") \
		$(use jack || echo "--no-jack --no-jack-session") \
		$(use swig || echo "--no-swig")
}

src_compile() {
	cd "${PN}"
	waf-utils_src_compile
}

src_install() {
	cd "${PN}"
	waf-utils_src_install
	dodoc AUTHORS ChangeLog README

	if use doc; then
		mv "${D}/usr/share/doc/${PN}/html" "${D}/usr/share/doc/${PF}"
		rmdir "${D}/usr/share/doc/${PN}"
		find "${D}/usr/share/doc/" -name '*.md5' -delete
	fi
}
