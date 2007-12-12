# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Event loop construct for Ruby"
HOMEPAGE="http://www.brockman.se/software/ruby-event-loop/"
SRC_URI="http://gimpel.ath.cx/~tom/files/event-loop-0.3.gem"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND="dev-ruby/rubygems"

src_install(){
	gems_src_install || die
}
