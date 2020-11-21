# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

SUPER_PN='amdgpu-pro'
MY_PV=$(ver_rs 2 '-')

DESCRIPTION="AMDGPU Pro Vulkan driver only"
HOMEPAGE="https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-20-45"
PKG_BASENAME="${SUPER_PN}-${MY_PV}-ubuntu-20.04"
SRC_URI="${PKG_BASENAME}.tar.xz"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

#S="${WORKDIR}/${PN}"

RESTRICT="bindist mirror fetch strip"

pkg_nofetch() {
	local pkgver=$(ver_cut 1-2)
	einfo "Please download the Radeon Software for Linux Driver ${pkgver} for Ubuntu 20.04.1 from"
	einfo "    ${HOMEPAGE}"
	einfo "The archive should then be placed into your distfiles directory."
}

src_unpack() {
	unpack "${SRC_URI}"
	mv  "${WORKDIR}"/"${PKG_BASENAME}"/vulkan-amdgpu-pro_${MY_PV}_amd64.deb "${WORKDIR}" || die
	rm -rf "${WORKDIR}"/"${PKG_BASENAME}" || die
	unpack "${WORKDIR}"/vulkan-amdgpu-pro_${MY_PV}_amd64.deb
	rm "${WORKDIR}"/vulkan-amdgpu-pro_${MY_PV}_amd64.deb || die
	mkdir "${S}" || die
	unpack "${WORKDIR}"/data.tar.xz
	rm "${WORKDIR}"/{control.tar.xz,data.tar.xz,debian-binary} || die
	rm -rf "${WORKDIR}"/etc || die
	mv {opt,usr} "${S}"/ || die
}

src_install() {
	dir_abi=x86_64-linux-gnu

	into "/opt/amdgpu"
	dolib.so "opt/${SUPER_PN}/lib/${dir_abi}"/*

	insinto "/opt/amdgpu-pro/etc/vulkan/icd.d"
	doins "opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd64.json"
}

pkg_postinst() {
	ewarn "Please note that using proprietary Vulkan libraries together with the"
	ewarn "Open Source amdgpu stack is not officially supported by AMD. Do not ask them"
	ewarn "for support in case of problems with this package."
	ewarn ""
	ewarn "Furthermore, if you have the whole AMDGPU-Pro stack installed this package"
	ewarn "will almost certainly conflict with it. This might change once AMDGPU-Pro"
	ewarn "has become officially supported by Gentoo."

	elog ""
	elog "loader in /opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd64.json"
	elog ""
	elog "lib in /opt/amdgpu-pro/lib/x86_64-linux-gnu/amdvlk64.so"
}
