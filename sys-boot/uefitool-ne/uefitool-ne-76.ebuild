EAPI=8

inherit cmake desktop

MY_PV="A${PV/_alpha/}"

DESCRIPTION="C++/Qt program to parse, extract and modify UEFI firmware images (new engine)"
HOMEPAGE="https://github.com/LongSoft/UEFITool"
SRC_URI="https://github.com/LongSoft/UEFITool/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-build/cmake-3.22
"

RESTRICT="mirror"

src_unpack() {
	default
	mv "UEFITool-${MY_PV}" "${P}" || die
}

src_configure() {
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	# Rename binaries to distinguish the new engine
	mv "${ED}/usr/bin/uefitool" "${ED}/usr/bin/UEFITool_ne" || die
	mv "${ED}/usr/bin/uefiextract" "${ED}/usr/bin/UEFIExtract_ne" || die
	mv "${ED}/usr/bin/uefifind" "${ED}/usr/bin/UEFIFind_ne" || die

	# Update desktop entry
	if [[ -f "${ED}/usr/share/applications/uefitool.desktop" ]]; then
		sed -i \
			-e 's/^Exec=uefitool/Exec=UEFITool_ne/' \
			"${ED}/usr/share/applications/uefitool.desktop" || die
	fi
}

