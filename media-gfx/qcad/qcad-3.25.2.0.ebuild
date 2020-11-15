# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils fdo-mime

DESCRIPTION="QCAD is a free, open source application for computer aided drafting (CAD) in two dimensions (2D)."
HOMEPAGE="http://www.qcad.org/en/"
SRC_URI="https://github.com/qcad/qcad/archive/v${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sys-apps/dbus
	>=dev-qt/qtcore-5.12
	>=dev-qt/qtprintsupport-5.12
	>=dev-qt/qtsvg-5.12
	>=dev-qt/qtopengl-5.12
	>=dev-qt/designer-5.12
	>=dev-qt/qtgui-5.12
	>=dev-qt/qthelp-5.12
	>=dev-qt/qtsql-5.12
	>=dev-qt/qtnetwork-5.12
	>=dev-qt/qtdbus-5.12
	>=dev-qt/qtwebengine-5.12
	>=dev-qt/qtscript-5.12[scripttools]
	>=dev-qt/qtxmlpatterns-5.12
	>=dev-qt/qtimageformats-5.12
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libSM
	virtual/glu
	media-libs/mesa
	media-libs/fontconfig
	media-libs/freetype
"
RDEPEND="${DEPEND}"

src_prepare() {
	#eapply -p2 "${FILESDIR}/fix_plugin_path.patch"
	eapply_user
	QTV=$(qmake -query | fgrep QT_VERSION | cut -d : -f 2)

	if [ ! -e src/3rdparty/qt-labs-qtscriptgenerator-$QTV ]
	then
		mkdir src/3rdparty/qt-labs-qtscriptgenerator-$QTV
		cat > src/3rdparty/qt-labs-qtscriptgenerator-$QTV/qt-labs-qtscriptgenerator-$QTV.pro <<EOF
include( ../../../shared.pri )

SUBDIRS = ../qt-labs-qtscriptgenerator-5.5.0/qtbindings
TEMPLATE = subdirs
EOF
	fi

	qmake -r
}

src_install() {
	#make install
	#dolib.so release/libdxflib.a
	#dolib.so release/libopennurbs.a
	#dolib.so release/libqcadcore.so
	#dolib.so release/libqcadecmaapi.so
	#dolib.so release/libqcadentity.so
	#dolib.so release/libqcadgrid.so
	#dolib.so release/libqcadgui.so
	#dolib.so release/libqcadoperations.so
	#dolib.so release/libqcadsnap.so
	#dolib.so release/libqcadspatialindex.so
	#dolib.so release/libqcadstemmer.so
	#dolib.so release/libspatialindexnavel.so
	#dolib.a release/libstemmer.a
	#dolib.a release/libzlib.a
	#dolib release/mainwindow_prototype
	#dobin release/qcad-bin
	#make_desktop_entry "$P" "QCAD $PV" "Graphics"

	#dolib.so "plugins"
	#for i in $(find "${WORKDIR}/" -type f -name '*.so' -o -name '*.so.*'); do
		#dolib.so "${i}"
	#done

	insinto /usr/lib64/qcad
	doins release/libqcadcore.so
	doins release/libqcadecmaapi.so
	doins release/libqcadentity.so
	doins release/libqcadgrid.so
	doins release/libqcadgui.so
	doins release/libqcadoperations.so
	doins release/libqcadsnap.so
	doins release/libqcadspatialindex.so
	doins release/libqcadstemmer.so
	doins release/libspatialindexnavel.so
	doins -r examples
	doins -r fonts
	doins -r libraries
	doins -r linetypes
	doins -r patterns
	doins -r plugins
	doins release/qcad-bin
	doins -r scripts
	doins -r themes
	doins -r ts
	doins -r xcbglintegrations

	doicon scripts/qcad_icon.png

	doman qcad.1
	domenu qcad.desktop

	fperms +x /usr/lib64/qcad/qcad-bin
	dosym /usr/lib64/qcad/qcad-bin /usr/bin/qcad

	#ls -lR "${D%/}"
	#mkdir "${D%/}"/usr/lib64/qcad/plugins || die
	#cp -rv "${S%/}"/plugins "${D%/}"/usr/lib64/qcad/plugins
}

pkg_postinst(){
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
