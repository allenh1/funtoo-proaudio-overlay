# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mm-sources/mm-sources-2.6.16_rc5-r3.ebuild,v 1.1 2006/03/08 08:22:55 voxus Exp $

K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"

ETYPE="sources"
inherit kernel-2 eutils fetch-tools reiser4-patch
detect_version
#get_realtime_patch_url
K_NOSETEXTRAVERSION="don't_set_it"

# minor version of mm-patch
MM_MIN_VER=mm1
##MY_PV="${PV/_/-}"

#MY_MM_BASE="${MY_PV}"
# base for mm-patch
MY_MM_BASE="2.6.17-rc4"

# URL's with possible location of the realtime-patch
# these URL's need to be passed to get_valid_url in
# SRC_URI
# eg. SRC_URI=`get_valid_url $FIRST_URL $SEC_URL`
P_URL="http://people.redhat.com/mingo/realtime-preempt"
FIRST_URL="${P_URL}/patch-${KV}"
SEC_URL="${P_URL}/older/patch-${KV}"

RESTRICT="nomirror"
DESCRIPTION="Ingo Molnars realtime patch applied on vanilla"
SRC_URI="${KERNEL_URI}
vesafb-tng? ( http://dev.gentoo.org/~spock/projects/vesafb-tng/archive/vesafb-tng-1.0-rc1-r3-2.6.16.patch ) 
http://proaudio.tuxfamily.org/files/patch-2.6.16-rt29-tglx4.bz2
fbsplash? ( http://proaudio.tuxfamily.org/patches/fbsplash-0.9.2-r5-2.6.16-rt.patch )"
#reiser4? ( http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/${MY_MM_BASE}/${MY_MM_BASE}-${MM_MIN_VER}/${MY_MM_BASE}-${MM_MIN_VER}-broken-out.tar.bz2 )"
#env|less
KEYWORDS="amd64 ~ppc ~ppc64 x86"
	
IUSE="fbsplash vesafb-tng realtime-lsm" #reiser4"
pkg_setup(){
	einfo "To enable additional patches for $PN use USE-flags"
	einfo
	einfo "fbsplash - Add support for framebuffer splash"
	einfo "vesafb-tng - Add a more functional version of the vesafb Linux driver"
	einfo "realtime-lsm - Add the deprecated realtime modul"
	sleep 3
}

src_unpack(){
	kernel-2_src_unpack
	
	# applying realtime patch (won't work with unipatch cause missing extension)
	epatch "${DISTDIR}/patch-${KV}-tglx4.bz2"
	
	# apply reiser4-patch
	#use reiser4 && add_reiser4 "${MY_MM_BASE}-${MM_MIN_VER}-broken-out.tar.bz2" \
	#"reiser4-vs-nfs-permit-filesystem-to-override-root-dentry-on-mount.patch reiser4-writeback-fix-range-handling.patch"
	
	#bug-fix  "reiser4-unix_file_write-get_exclusive_access-carefully"
	##use reiser4 && epatch ${FILESDIR}/reiser4-unix_file_write-get_exclusive_access-carefully.diff

	# realtime-lsm and vesafb-tng fbsplash
	use realtime-lsm && epatch "${FILESDIR}/realtime-lsm-0.8.6.gz"
	use vesafb-tng && epatch "${DISTDIR}/vesafb-tng-1.0-rc1-r3-2.6.16.patch"
	use fbsplash && epatch "${DISTDIR}/fbsplash-0.9.2-r5-2.6.16-rt.patch"
	epatch "${FILESDIR}/input_device_id-to-mod_devicetable.patch"
}

K_EXTRAEINFO="This kernel is not supported by Gentoo If you have any issues, try
a matching vanilla-sources ebuild -- if the problem persists there, please file
a bug at http://bugme.osdl.org. If the problem only occurs with rt-sources then
please contact Ingo Molnar on the kernel mailinglist to get your issue resolved.
But first search the mailinglist-archiv if your problem is already 
discussed/solved: http://lkml.org/
Recommended other packages: sys-process/rtirq and sys-apps/das_watchdog"
