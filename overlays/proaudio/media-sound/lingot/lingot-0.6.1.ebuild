# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/lingot/lingot-0.6.1.ebuild,v 1.1 2006/04/10 16:34:24 gimpel Exp $

DESCRIPTION="LINGOT is a musical instrument tuner. It's accurate, easy to use,
and highly configurable."
HOMEPAGE="http://www.nongnu.org/lingot/"
SRC_URI="http://savannah.nongnu.org/download/lingot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-1.2"

src_install() {
	dobin ${PN}
	dodoc README
}
