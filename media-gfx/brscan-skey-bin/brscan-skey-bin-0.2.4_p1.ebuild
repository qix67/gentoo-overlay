# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm eutils

MY_PV="${PV/_p/-}"

DESCRIPTION="Brother scan-key-tool"
HOMEPAGE="http://support.brother.com/g/s/id/linux/en"
SRC_URI="http://download.brother.com/welcome/dlf006650/${PN/-bin}-${MY_PV}.x86_64.rpm"

RESTRICT="strip mirror"

LICENSE="Brother-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-gfx/brscan5-bin"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_unpack() {
	rpm_unpack ${A}

	# install script is very stupid
	# we must patch it to obtain files installed in the proper place
	sed -i -e "s#^BASEDIR=\"#BASEDIR=\"${WORKDIR}#" "${WORKDIR}/opt/brother/scanner/brscan-skey/brscan-skey-${MY_PV}.sh"

	sh "${WORKDIR}/opt/brother/scanner/brscan-skey/brscan-skey-${MY_PV}.sh"

	# however we must patched files produced by install script because they are created
	# at the correct place but with the wrong path.
	sed -i -e "s#${WORKDIR}/opt/brother/scanner/brscan-skey/#/opt/brother/scanner/brscan-skey/#" "${WORKDIR}"/opt/brother/scanner/brscan-skey/script/*.sh

	chmod +x "${WORKDIR}"/opt/brother/scanner/brscan-skey/script/*.sh
}

src_install() {
	exeinto /opt/brother/scanner/brscan-skey
	doexe /opt/brother/scanner/brscan-skey/brscan-skey
	doexe /opt/brother/scanner/brscan-skey/brscan-skey-0.2.4-0

	exeinto /opt/brother/scanner/brscan-skey/script
	doexe /opt/brother/scanner/brscan-skey/script/brscan_scantoemail-*
	# why the following doexe does not work with a heading '/' ???
	doexe opt/brother/scanner/brscan-skey/script/scanto*.sh

	dosym /opt/brother/scanner/brscan-skey/brscan-skey /usr/bin/brscan-skey

	insinto /opt/brother/scanner/brscan-skey
	doins  /opt/brother/scanner/brscan-skey/brscan-skey-0.2.4-0.cfg

	doinitd "${FILESDIR}"/brscan-skey
}

