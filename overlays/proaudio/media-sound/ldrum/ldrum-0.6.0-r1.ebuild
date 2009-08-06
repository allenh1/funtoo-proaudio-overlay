# Copyright 2004 Peter Eschler
# Copyright 2006 evermind
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
inherit kde-functions
need-qt 3

DESCRIPTION="The LDrum is an open-source drummachine that offers ten sample channels, realtime control, a simple pattern sequencer, MIDI support and a Qt-GUI"
HOMEPAGE="http://ldrum.sf.net/"
SRC_URI="mirror://sourceforge/ldrum/${P}.tgz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
MAKEOPTS="-j1"

DEPEND=">=x11-libs/qt-3.1.1
	media-sound/jack-audio-connection-kit
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/libsndfile-1.0.5
	>=media-libs/libsamplerate-0.0.14"

src_compile() {
	# patching to use the 3.x version of qmake	START
	for i in `find -iname '*.pro.in'`;do echo "QMAKE=/usr/qt/3/bin/qmake"  >> "${i}";done
	sed  -i "s|string\ XMLNode\:\:name(string\ _name\=\"\")|string\ name(string\ _name\=\"\")|g" xmlpp/src/xmlpp.h
	sed -i "s|ac_qmake\ \=\ \@ac_qmake\@|ac_qmake\ \=\ /usr/qt/3/bin/qmake|g" xmlpp/test/Makefile.in
	sed -i "s|ac_qmake\ \=\ \@ac_qmake\@|ac_qmake\ \=\ /usr/qt/3/bin/qmake|g" xmlpp/Makefile.in
	sed -i "s|ac_qmake\ \=\ \@ac_qmake\@|ac_qmake\ \=\ /usr/qt/3/bin/qmake|g" xmlpp/src/Makefile.in
	for i in `find -iname '*.in'`;do sed -i "s|qmake\ \=\ \@ac_qmake\@|qmake\ \=\ /usr/qt/3/bin/qmake|g" "${i}";done
	for i in `find -iname '*.in'`;do sed -i "s|ac_uic\ \=\ \@ac_uic\@|ac_uic\ \=\ /usr/qt/3/bin/uic|g" "${i}";done
	 for i in `find -iname '*.in'`;do sed -i "s|ac_moc\ \=\ \@ac_moc\@|ac_moc\ \=\ /usr/qt/3/bin/moc|g" "${i}";done
	# patching to use the 3.x version of qmake  END

	# add -lrt to  engine/Makefile.in and gui/gui.pro
	sed -i "s|-ljack\ -lasound|-ljack\ -lasound\ -lrt|g" engine/Makefile.in ||die
	sed -i "s|-lsamplerate\ -lsndfile\ -lasound\ -ljack|-lsamplerate\ -lsndfile\ -lasound\ -ljack\ -lrt|g" engine/Makefile.in || die
	sed -i -e "s:^\(LIBS.*\):\1 -lrt:" gui/gui.pro.in || die

	# add missing header-files
	sed -i '1i#include <time.h>'  widgets/floatdial.h || die
	sed -i '1i#include <math.h>'  widgets/floatdial.h || die
	#testSequence_LDADD = $(top_builddir)/engine/libldrumengine.a
	#$(top_builddir)/jackpp/src/libjackpp.a -lsndfile -lsamplerate -ljack
	#-lasound -lrt
	libtoolize --copy --force
	econf || die
	### borrowed from kde.eclass #
	#
	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox,
	# so that the build process can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"

	emake || die
}

src_install() {
	einstall || die "make install failed"
}
