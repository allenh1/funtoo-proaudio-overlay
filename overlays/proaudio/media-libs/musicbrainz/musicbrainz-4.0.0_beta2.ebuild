# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit cmake-utils versionator
MY_PN="lib${PN}"
MY_PV=$(delete_version_separator '_')
MY_P="${MY_PN}-${MY_PV}"


DESCRIPTION="Client library to access metadata of mp3/vorbis/CD media"
HOMEPAGE="http://musicbrainz.org/"
SRC_URI="ftp://ftp.musicbrainz.org/pub/musicbrainz/libmusicbrainz-4.0.0beta2.tar.gz"

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

RDEPEND="net-libs/neon"

DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

S=${WORKDIR}/${MY_P}
CMAKE_IN_SOURCE_BUILD=True

use debug && CMAKE_BUILD_TYPE=Debug

DOCS="README.txt NEWS.txt AUTHORS.txt"
