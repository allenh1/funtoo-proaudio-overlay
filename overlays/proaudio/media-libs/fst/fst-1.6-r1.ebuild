# installs libfst, using sdk from /opt/VST Plug-Ins SDK 2.3
# bug #61300

inherit eutils

RESTRICT="mirror"

DESCRIPTION="FreeST audio plugin VST container library"
HOMEPAGE="http://www.linuxaudiosystems.com/fst/"
LICENSE="GPL-2"
SLOT="0"
SRC_URI="http://www.linuxaudiosystems.com/fst/${P}.tar.gz"

KEYWORDS=""
DEPEND="app-emulation/wine
	>=media-libs/vst-sdk-2.3"

VSTSDK_DIR="/opt/VST_Plug-Ins_SDK_2.3"

src_unpack() {
	unpack ${P}.tar.gz || die
	epatch "${FILESDIR}"/fst-1.6-wineliblocfix.patch
	cd "${WORKDIR}/${P}"
	mkdir "${WORKDIR}/${P}"/vst
	cp "${VSTSDK_DIR}"/vstsdk2.3/source/common/AEffect.h \
	   "${VSTSDK_DIR}"/vstsdk2.3/source/common/aeffectx.h \
		vst/
	cd "${WORKDIR}/${P}"/vst
	../fixheaders
	epatch "${FILESDIR}"/vsthcompilerhack_fix.patch
}

src_compile() {
	cd "${WORKDIR}/${P}"
	aclocal $ACLOCAL_FLAGS || die
	autoconf || die
	automake -a -c

	local myconf

	EXTRA_ECONF="${EXTRA_ECONF} \
		--with-wine-includes=/usr/lib/wine/include/wine/windows \
		--with-wine-libraries=/usr/lib/wine/lib \
		--with-wine-tools=/usr/lib/wine/bin"

	./configure \
		--prefix=/usr \
		--host=${CHOST} \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		${EXTRA_ECONF}
	emake
}

src_install() {
	cd ${WORKDIR}/${P}

	# /usr/include/fst.h
	dodir /usr/include
	insinto /usr/include
	doins fst/fst.h

	# /usr/include/vst/*
	dodir /usr/include/vst
	insinto /usr/include/vst
	doins vst/AEffect.h
	doins vst/aeffectx.h

	# /usr/lib/libfst.so
	dodir /usr/lib
	insinto /usr/lib
	doins fst/libfst.so

	# /usr/lib/pkgconfig/libfst.pc
	dodir /usr/lib/pkgconfig
	insinto /usr/lib/pkgconfig
	doins libfst.pc

	dodoc README AUTHORS COPYING ChangeLog
}
