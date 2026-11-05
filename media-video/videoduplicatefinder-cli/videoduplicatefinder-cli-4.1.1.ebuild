# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Video Duplicate Finder - command line interface"
HOMEPAGE="https://github.com/0x90d/videoduplicatefinder"
SRC_URI="https://github.com/0x90d/videoduplicatefinder/releases/download/v${PV}/CLI-linux-x64.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND="
	>=media-video/ffmpeg-8
"

S="${WORKDIR}"

QA_PREBUILT="/opt/${PN}/*"

src_install() {
	insinto /opt/videoduplicatefinder-cli
	doins -r outputCLI/.

	fperms 0755 /opt/videoduplicatefinder-cli/vdf-cli

	dosym /opt/videoduplicatefinder-cli/vdf-cli /usr/bin/vdf-cli
}
