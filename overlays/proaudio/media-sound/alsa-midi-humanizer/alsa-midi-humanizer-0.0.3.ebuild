# Copyright 1999-2006 Gentoo Foundation 
# Distributed under the terms of the GNU General Public License v2
# $Header: $


RESTRICT="nomirror"
MY_P="${P/alsa-midi-h/ALSA-MIDI-H}"
DESCRIPTION="ALSA MIDI Humanizer is a tiny utility application that routes MIDI events between two applications adding random timing and velocity offsets to NOTEON and NOTEOFF events"
SRC_URI="http://www.cesaremarilungo.com/download/${MY_P}.tar.gz"
HOMEPAGE="http://www.cesaremarilungo.com/sw/alsamidihumanizer.php"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 ~amd64"

IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0
		>=media-libs/alsa-lib-1.0.3"

DEPEND="${RDEPEND}
    dev-util/pkgconfig"


S="${WORKDIR}/${MY_P}"
src_unpack() {
	unpack "${A}"
	cd "${S}"
cat > Makefile << EOF
PREFIX = /usr
TARGET = humanizer
INSTALL = /usr/bin/install
RM = rm
all:
	\$(CC) \$(CFLAGS) humanizer.c -o humanizer -lasound -lpthread \`pkg-config --cflags --libs gtk+-2.0\`

install:
	\$(INSTALL) -d \$(DESTDIR)\$(PREFIX)/bin
	\$(INSTALL) -m755 \$(TARGET) \$(DESTDIR)\$(PREFIX)/bin

clean:
	\$(RM) \$(TARGET)
EOF
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
}
