# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="sasutils eases the administration of Serial Attached SCSI (SAS) fabrics."
HOMEPAGE="https://github.com/stanford-rc/sasutils"
SRC_URI="https://github.com/stanford-rc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/mutable_mapping.patch"
)

DEPEND="
	sys-apps/sg3_utils
	sys-block/smp_utils"
RDEPEND="${DEPEND}"
BDEPEND=""

RESTRICT="mirror"

S=${WORKDIR}/${P}/src

src_unpack() {
	mkdir -p "${P}"/src || die

	tar -C "${P}"/src --strip-components=1 -xzf "${DISTDIR}/${P}.tar.gz" || die
}

src_prepare() {
	# apply patches relatively to top directory
	cd "${WORKDIR}/${P}" || die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all

	cd "${WORKDIR}/${P}/src/doc/man/man1" || die

	doman *.1
}
