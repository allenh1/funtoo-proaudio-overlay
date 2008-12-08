# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils libtool

MY_P="${P/_/~}"

DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash/"
SRC_URI="http://download.savannah.gnu.org/releases/lash/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa debug gtk python"

RDEPEND="alsa? ( media-libs/alsa-lib[midi] )
	media-sound/jack-audio-connection-kit
	dev-libs/libxml2
	gtk? ( >=x11-libs/gtk+-2.0 )
	python? ( dev-lang/python )
	|| ( sys-libs/readline dev-libs/libedit )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	python? ( >=dev-lang/swig-1.3.31 )"

S="${WORKDIR}/${PN}-0.6.0.594"

src_compile() {
	local myconf

	# Yet-another-broken-configure: --enable-pylash would disable it.
	use python || myconf="${myconf} --disable-pylash"

	econf \
		$(use_enable alsa alsa-midi) \
		$(use_enable gtk gtk2) \
		$(use_enable debug) \
		${myconf} \
		--disable-serv-inst \
		--disable-dependency-tracking \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst(){
	if [ ! $(grep -q ^lash /etc/services) ] || [ $(grep -q ^ladcca /etc/services) ] ; then
		# cleanup trailing blank lines in /etc/service
		sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/services
		# check for old ladcca entries and remove
		if grep -q ^ladcca /etc/services; then
			sed -i /ladcca/d /etc/services
		fi
		# add new lash entry
		if ! grep -q ^lash /etc/services ; then
			cat >>/etc/services<<-EOF

lash		14541/tcp			# LASH client/server protocol
EOF
		fi
	fi
}

pkg_postrm(){
	# cleanup /etc/services
	if grep -q ^lash /etc/services; then
		einfo "cleaning lash entries frome /etc/services"
		sed -i /lash/d /etc/services
	fi
	# cleanup trailing blank lines in /etc/service
	sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/services
	einfo "if programs which use lash fails try:"
	einfo "revdep-rebuild --library="liblash.so.*""
}
