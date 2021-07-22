# Copyright 2016 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

MY_PV="A${PV/_alpha/}"

DESCRIPTION="C++/Qt program to parse, extract and modify UEFI firmware images (new engine)"
HOMEPATH="https://github.com/LongSoft/UEFITool"
SRC_URI="https://github.com/LongSoft/UEFITool/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"

SLOT="0"

KEYWORDS="~amd64"
IUSE=""

DEPEND=(
	"dev-qt/qtcore:5"
	"dev-qt/qtgui:5"
	"dev-qt/qtwidgets:5"
)
RDEPEND=( "${DEPEND}" )

RESTRICT="mirror"

src_unpack() {
	default
	mv "UEFITool-${MY_PV}" "${P}"
}

src_prepare() {
	eapply_user

	echo "$S"
	sed -e "s/^    make || exit 1/    make ${MAKEOPTS} || exit 1/" -i "${S}/unixbuild.sh" || die "sed failed"
}

UEFI_PROGS=( UEFIExtract UEFIFind UEFITool )

src_configure() {
	./unixbuild.sh --configure
}

src_compile() {
	./unixbuild.sh --build
}

src_install() {
	for prog in "${UEFI_PROGS[@]}"
	do
		cd "${prog}"
		mv "${prog}" "${prog}_ne"
		dobin "${prog}_ne"
		cd "${S}"
	done

	make_desktop_entry "UEFITool_ne -- %f" "UEFITool (new engine)" "utilities-terminal" "System;Utility;FileTools"
}

