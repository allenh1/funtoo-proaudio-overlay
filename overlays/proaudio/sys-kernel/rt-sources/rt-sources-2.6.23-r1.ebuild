# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"

ETYPE="sources"
inherit kernel-2 eutils fetch-tools reiser4-patch patcher
detect_version
#get_realtime_patch_url
K_NOSETEXTRAVERSION="don't_set_it"

# minor version of mm-patch
MM_MIN_VER=mm1
##MY_PV="${PV/_/-}"

#MY_MM_BASE="${MY_PV}"
# base for mm-patch
MY_MM_BASE="2.6.17-rc4"

UVESAFB="uvesafb-0.1-rc3-2.6.23-rc3.patch"
FBSPLASH="fbcondecor-0.9.4-2.6.23-rc7_for_rt.patch"
RT_PATCH="patch-${KV}.bz2"

RESTRICT="nomirror"
DESCRIPTION="Ingo Molnars realtime patch applied on vanilla"
SRC_URI="${KERNEL_URI}
http://download.tuxfamily.org/proaudio/realtime-patches/${RT_PATCH}
uvesafb? ( http://proaudio.tuxfamily.org/patches/${UVESAFB} ) 
fbsplash? ( http://proaudio.tuxfamily.org/patches/${FBSPLASH} )"
#reiser4? ( http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/${MY_MM_BASE}/${MY_MM_BASE}-${MM_MIN_VER}/${MY_MM_BASE}-${MM_MIN_VER}-broken-out.tar.bz2 )"
#env|less
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE="fbsplash uvesafb" #realtime-lsm" #reiser4"
pkg_setup(){
	einfo "To enable additional patches for $PN use USE-flags"
	einfo
	einfo "fbsplash - Add support for framebuffer splash"
	einfo "uvesafb - Add a more functional version of the vesafb Linux driver"
	einfo "realtime-lsm - seems to be included in the rt-patch"
	#Add the deprecated realtime modul"
	sleep 3
}

src_unpack(){
	kernel-2_src_unpack
	
	# applying realtime patch (won't work with unipatch cause missing extension)
	epatch "${DISTDIR}/${RT_PATCH}"
	
	# apply reiser4-patch
	#use reiser4 && add_reiser4 "${MY_MM_BASE}-${MM_MIN_VER}-broken-out.tar.bz2" \
	#"reiser4-vs-nfs-permit-filesystem-to-override-root-dentry-on-mount.patch reiser4-writeback-fix-range-handling.patch"
	
	#bug-fix  "reiser4-unix_file_write-get_exclusive_access-carefully"
	##use reiser4 && epatch ${FILESDIR}/reiser4-unix_file_write-get_exclusive_access-carefully.diff

	# fix sandbox_problems
	epatch "${FILESDIR}/build-id-sandbox-violation.patch" || die "Sandbox patch failed"
	# realtime-lsm and vesafb-tng fbsplash
	#use realtime-lsm && epatch "${FILESDIR}/realtime-lsm-0.8.6_2.6.19.gz"
	use uvesafb && patcher "${DISTDIR}/${VESAFB} apply"
	use fbsplash && patcher "${DISTDIR}/${FBSPLASH} apply"
	
	# expose 1gig lowmem options (x86 only)
	#patcher "${FILESDIR}/kconfig-expose_vmsplit_option.patch apply"
}

K_EXTRAEINFO="This kernel is not supported by Gentoo If you have any issues, try
a matching vanilla-sources ebuild -- if the problem persists there, please file
a bug at http://bugme.osdl.org. If the problem only occurs with rt-sources then
please contact Ingo Molnar on the kernel mailinglist to get your issue resolved.
But first search the mailinglist-archiv if your problem is already 
discussed/solved: http://lkml.org/ and
http://www.mail-archive.com/linux-rt-users@vger.kernel.org/ .
Recommended other packages: sys-process/rtirq and sys-apps/das_watchdog"
