# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Video Duplicate Finder - graphical interface"
HOMEPAGE="https://github.com/0x90d/videoduplicatefinder"
SRC_URI="https://github.com/0x90d/videoduplicatefinder/releases/download/v${PV}/GUI-linux-x64.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND="
	>=media-video/ffmpeg-8
	dev-libs/wayland
	x11-libs/libX11
"

S="${WORKDIR}"

QA_PREBUILT="/opt/${PN}/*"

src_install() {
	insinto /opt/videoduplicatefinder
	doins -r outputGUI/.

	fperms 0755 /opt/videoduplicatefinder/VDF.GUI

	dosym /opt/videoduplicatefinder/VDF.GUI /usr/bin/vdf-gui

	newicon outputGUI/icon.png videoduplicatefinder.png
	make_desktop_entry vdf-gui "Video Duplicate Finder" videoduplicatefinder
}
