# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools versionator toolchain-funcs

RESTRICT="nomirror"
DESCRIPTION="GNU Music Typesetter"
SRC_URI="http://download.linuxaudio.org/lilypond/sources/v$(get_version_component_range 1-2)/${P}.tar.gz"
HOMEPAGE="http://lilypond.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"

# for documentation
LANGS="fr"
IUSE="debug doc emacs gtk profile vim"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X/-/_}"
done

RDEPEND="
	>=media-libs/freetype-2
	media-libs/fontconfig
	>=x11-libs/pango-1.12.3
	>=dev-scheme/guile-1.8.1
	>=dev-lang/python-2.4
	|| (	>=app-text/ghostscript-gnu-8.15
		>=app-text/ghostscript-gpl-8.15
		>=app-text/ghostscript-esp-8.15 )
	virtual/tetex
	gtk? ( >=x11-libs/gtk+-2.4 )"

DEPEND="${RDEPEND}
	>=media-gfx/fontforge-20060125
	>=app-text/mftrace-1.1.19
	>=sys-apps/texinfo-4.8
	sys-devel/gettext
	>=sys-devel/bison-2.0
	doc? (	media-libs/netpbm
		|| ( >=app-text/ghostscript-gnu-8.54 >=app-text/ghostscript-gpl-8.54 )
		media-gfx/imagemagick )"

src_unpack() {
	unpack ${A}; cd ${S}

	# help2man runs scripts directly, so they need to be able to find modules
	# in build directory (otherwise they look in ${ROOT} and violate sandbox)
	for dir in scripts/{share,lib}/lilypond/current; do
		mkdir -p ${dir}
		ln -s ${S}/python ${dir}/python
	done
	
	if use doc; then
		local mylangs="site"
		use linguas_fr && mylangs="${mylangs}, fr"
		sed -e "s/^LANGUAGES = .*/LANGUAGES = (${mylangs}, )/" \
			-i	buildscripts/langdefs.py || die "sed failed"
	fi
}

src_compile() {
	if [[ $(gcc-major-version) -lt 4 ]]; then
		eerror "You need GCC 4.x to build this software."
		die "you need to compile with gcc-4 or later"
	fi
	local flags="deprecated regex"
	built_with_use dev-scheme/guile ${flags} || die "guile must be built with \"${flags}\" use flags"

	econf \
		$(use_enable debug debugging) \
		$(use_enable profile profiling) \
		$(use_enable doc documentation) \
		$(use_enable gtk gui) \
		--with-ncsb-dir=/usr/share/fonts/default/ghostscript \
		|| die "econf failed"

	# make sure lilypond-book can find modules in build directory (otherwise
	# it finds installed lilypond in ${ROOT} and violates sandbox)
	export LILYPOND_DATADIR=${S}/out/share/lilypond/current

	# parallel make errors
	emake -j1 || die "emake failed"

	if use doc; then
		emake -j1 web || die "emake web failed"
	fi
}

src_install () {
	# make sure lilypond-book can find modules in build directory (otherwise
	# it finds installed lilypond in ${ROOT} and violates sandbox)
	export LILYPOND_DATADIR=${S}/out/share/lilypond/current

	emake DESTDIR=${D} vimdir=/usr/share/vim/vimfiles install \
		|| die "emake install failed"
	
	if use doc; then
		# Note: installs .html docs, .pdf docs and examples
		emake out=www web-install DESTDIR=${D} \
			webdir=/usr/share/doc/${PF}/html || die "emake web-install failed"
	fi

	dodoc AUTHORS.txt ChangeLog DEDICATION NEWS.txt README.txt THANKS

	use vim || rm -r ${D}/usr/share/vim
	use emacs || rm -r ${D}/usr/share/emacs
}
