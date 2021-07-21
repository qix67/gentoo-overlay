# Copyright 2016 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

MY_PV="A${PV/_alpha/}"
MY_PN="${PN}-${MY_PV}"

DESCRIPTION="C++/Qt program for parsing, extracting and modifying UEFI firmware images"
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
		dobin "${prog}"
		cd "${S}"
	done

	make_desktop_entry "UEFITool -- %f" "UEFITool" "utilities-terminal" "System;Utility;FileTools"
}

