# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit unpacker

RESTRICT="nomirror"
DESCRIPTION="free drumkits for hydrogen"
HOMEPAGE="http://www.hydrogen-music.org"
SRC_URI="mirror://sourceforge/hydrogen/MilloDrums-3.zip
	http://rolandclan.info/media/samples/dr-110/Boss_DR-110.h2drumkit
	http://rolandclan.info/media/samples/v-synth/V-Synth_VariBreaks.h2drumkit
	http://rolandclan.info/media/samples/tr-626/Roland_TR-626.h2drumkit
	http://rolandclan.info/media/samples/tr-909/Roland_TR-909.h2drumkit
	http://rolandclan.info/media/samples/tr-808/Roland_TR-808.h2drumkit
	http://rolandclan.info/media/samples/tr-707/Roland_TR-707.h2drumkit
	http://rolandclan.info/media/samples/tr-606/Roland_TR-606.h2drumkit
	http://artemiolabs.com/downloads/audio/hydrogen/EE.tar.bz2
	http://artemiolabs.com/downloads/audio/hydrogen/TR808EK.tar.bz2
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
DEPEND="media-sound/hydrogen"

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
