# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils udev versionator git-r3

DESCRIPTION="USB-based electronics prototyping platform compatible with Arduino"
HOMEPAGE="https://www.pjrc.com/teensy/"

MY_PV="$(replace_all_version_separators '')"
MY_PN="${PN/-bin}"

ARDUINO_PN="arduino"

ARDUINOVER="1.8.13"

EGIT_COMMIT="e98b5065cdb9f04aa4dde3f2e6e6e6f12dd97592"
EGIT_REPO_URI="https://github.com/PaulStoffregen/teensy_loader_cli.git"

SRC_URI="http://downloads.arduino.cc/arduino-${ARDUINOVER}-linux64.tar.xz \
         https://www.pjrc.com/teensy/td_${PV//./}/TeensyduinoInstall.linux64"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

RESTRICT="binchecks preserve-libs strip"

src_unpack() {
	# unpack arduino in workdir
	unpack "arduino-${ARDUINOVER}-linux64.tar.xz"

	cp /usr/portage/distfiles/TeensyduinoInstall.linux64 "${WORKDIR}" || die

	chmod +x "${WORKDIR}"/TeensyduinoInstall.linux64
	"${WORKDIR}"/TeensyduinoInstall.linux64  --dir="${WORKDIR}/arduino-${ARDUINOVER}" || die
	cp "${FILESDIR}"/49-teensy.rules "${WORKDIR}" || die

	rm "${WORKDIR}"/TeensyduinoInstall.linux64

	# remove files with unresolved dependencies
	rm "${WORKDIR}"/"arduino-${ARDUINOVER}"/hardware/tools/arm/bin/arm-none-eabi-gdb
	rm "${WORKDIR}"/"arduino-${ARDUINOVER}"/java/lib/amd64/libavplugin-{53,54,55,56,57}.so
	rm "${WORKDIR}"/"arduino-${ARDUINOVER}"/java/lib/amd64/libavplugin-ffmpeg-{56,57}.so

	mv "${WORKDIR}"/"arduino-${ARDUINOVER}" "teensyduino-bin"
}

src_install() {
	newicon lib/arduino.png "${MY_PN}".png
	make_desktop_entry "${MY_PN}" Teensyduino "${MY_PN}"

	mkdir -p "${D}"/opt/"${PN}" || die
	cp -a * "${D}"/opt/"${PN}" || die

	make_wrapper ${MY_PN} "${EROOT}opt/${PN}/${ARDUINO_PN}" "${EROOT}opt/${PN}"

	udev_dorules "${WORKDIR}"/49-teensy.rules
}

pkg_postinst() {
	udev_reload

	elog "Initial setup for your Teensy requires you to plug in the board,"
	elog "verify a sketch, then press the reset button on the board. After"
	elog "that, you can use the upload button."
}
