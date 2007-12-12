# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/x4x/x4x-portage/dev-ruby/event-loop/event-loop-0.3.ebuild,v 1.1 2007/06/19 21:38:11 dangertools Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Event loop construct for Ruby"
HOMEPAGE="http://www.brockman.se/software/ruby-event-loop/"
#SRC_URI="http://www.brockman.se/software/ruby-event-loop/${P}.gem"
SRC_URI="http://ftp.de.debian.org/debian/pool/main/libe/libevent-loop-ruby/libevent-loop-ruby_0.3.orig.tar.gz"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND="dev-ruby/rubygems"

src_compile() {
	RUBY_ECONF="--prefix=${D}/usr"	
	ruby_src_configure
}

src_install(){
	ruby_src_install
	#gems_src_install || die
}
