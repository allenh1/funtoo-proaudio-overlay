# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit unpacker

RESTRICT="nomirror"
DESCRIPTION="free drumkits for hydrogen"
HOMEPAGE="http://www.hydrogen-music.org"
PRO_MIRROR="http://download.tuxfamily.org/proaudio/distfiles"
SRC_URI="mirror://sourceforge/hydrogen/MilloDrums-3.zip
	${PRO_MIRROR}/Boss_DR-110.h2drumkit
	${PRO_MIRROR}/V-Synth_VariBreaks.h2drumkit
	${PRO_MIRROR}/Roland_TR-626.h2drumkit
	${PRO_MIRROR}/Roland_TR-909.h2drumkit
	${PRO_MIRROR}/Roland_TR-808.h2drumkit
	${PRO_MIRROR}/Roland_TR-707.h2drumkit
	${PRO_MIRROR}/Roland_TR-606.h2drumkit
	${PRO_MIRROR}/EE.tar.bz2
	${PRO_MIRROR}/TR808EK.tar.bz2
	mirror://sourceforge/hydrogen/ErnysPercussion.h2drumkit
	mirror://sourceforge/hydrogen/Millo_MultiLayered2.h2drumkit
	mirror://sourceforge/hydrogen/HardElectro1.tar.gz
	mirror://sourceforge/hydrogen/Millo-Drums_v1.tar.gz
	mirror://sourceforge/hydrogen/EasternHop-1.tar.gz
	mirror://sourceforge/hydrogen/TD-7.tar.gz
	mirror://sourceforge/hydrogen/3355606.tar.gz
	mirror://sourceforge/hydrogen/DrumkitPack2.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""
RDEPEND="media-sound/hydrogen"
DEPEND="app-arch/unzip"

src_unpack(){
	# unpack all files given in $A
	# seperate h2drumkit to dir drum_kits/
	# other to dir packed/
	B=$A
	IFS=" "
	set -- ${B}
	B=($B)
	mkdir -p ${S}/drum_kits  ${S}/packed
	for i in "${B[@]}";do
		if [ "${i##*.}" == "h2drumkit" ];then
			UNPACK_DESTDIR="${S}/drum_kits/" unpacker $i
		else
			UNPACK_DESTDIR="${S}/packed/" unpacker $i
		fi
	done

	# unpack all drumkits from dir packed/ to drum_kits/
	cd ${S}/packed/
	dkit="`find -iname '*.h2drumkit' -printf "\"${S}/packed/%P\" "`"
	UNPACK_DESTDIR="${S}/drum_kits" unpacker $dkit
	
	# mv all demo songs to demo_songs/
	cd ${S}
	mkdir demo_songs
	find -iname '*.h2song' -exec mv {}  ${S}/demo_songs/ \;
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	insinto  /usr/share/hydrogen/data/drumkits/
	doins -r drum_kits/*
	insinto /usr/share/hydrogen/data/demo_songs/
	doins -r demo_songs/*

}
