# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mm-sources/mm-sources-2.6.16_rc5-r3.ebuild,v 1.1 2006/03/08 08:22:55 voxus Exp $

K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"

ETYPE="sources"
inherit kernel-2 eutils fetch-tools
detect_version
K_NOSETEXTRAVERSION="don't_set_it"

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
http://dev.gentoo.org/~spock/projects/vesafb-tng/archive/vesafb-tng-1.0-rc1-r3-2.6.15-rc1.patch
$(get_valid_url "${FIRST_URL}" "${SEC_URL}")"

KEYWORDS="-* ~amd64 ~ppc ~ppc64 x86"
IUSE=""

src_unpack(){
	kernel-2_src_unpack
	epatch "${DISTDIR}/patch-${KV}"
	epatch "${FILESDIR}/realtime-lsm-0.8.6.gz"
	epatch "${DISTDIR}/vesafb-tng-1.0-rc1-r3-2.6.15-rc1.patch"
}

K_EXTRAEINFO="This kernel is not supported by Gentoo If you have any issues, try
a matching vanilla-sources ebuild -- if the problem persists there, please file
a bug at http://bugme.osdl.org. If the problem only occurs with rt-sources then
please contact Ingo Molnar on the kernel mailinglist to get your issue resolved.
But first search the mailinglist-archiv if your problem is already 
discussed/solved: http://lkml.org/
Recommended other packages: sys-process/rtirq and sys-apps/das_watchdog"
