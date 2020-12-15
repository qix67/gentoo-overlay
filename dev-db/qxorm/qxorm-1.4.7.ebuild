# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="QxOrm library - C++ Qt ORM (Object Relational Mapping) and ODM (Object Document Mapper) library"
HOMEPAGE="https://www.qxorm.com/qxorm_en/home.html"
SRC_URI="https://github.com/QxOrm/QxOrm/archive/${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+boost qtgui qtnetwork -mongodb"

DEPEND="
	virtual/pkgconfig
	>=dev-qt/qtcore-5.8
	>=dev-qt/qtsql-5.8
	boost? (
		>=dev-libs/boost-1.38.0
	)
	qtgui? (
		>=dev-qt/qtgui-5.8
	)
	qtnetwork? (
		>=dev-qt/qtnetwork-5.8
	)
	mongodb? (
		>=dev-libs/mongo-c-driver-1.0
		>=dev-libs/libbson-1.0
	)
"

RDEPEND="${DEPEND}"

RESTRICT="mirror"

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi

	mv "${WORKDIR}"/QxOrm-"${PV}" "${WORKDIR}"/qxorm-"${PV}"
}

src_configure() {
	local myqmakeargs=( )

	if use boost; then
		myqmakeargs+=( 'DEFINES+=_QX_ENABLE_BOOST'
							'DEFINES+=_QX_ENABLE_BOOST_SERIALIZATION' 
							'QX_BOOST_INCLUDE_PATH=/usr/include/' 
							'QX_BOOST_LIB_PATH=/usr/lib64' )
	fi

	if use qtgui; then
		myqmakeargs+=( 'DEFINES+=_QX_ENABLE_QT_GUI' )
	fi

	if use qtnetwork; then
		myqmakeargs+=( 'DEFINES+=_QX_ENABLE_QT_NETWORK')
	fi

	if use mongodb; then
		myqmakeargs+=( 'DEFINES+=_QX_ENABLE_MONGODB' 
							'QX_BSON_LIB_PATH=/usr/lib64/' 
							'QX_MONGOC_LIB_PATH=/usr/lib64/'
						)

		local mongoc_version=$(pkg-config --list-all | sed -e '/^libmongoc-[0-9]/!d' -e 's/^libmongoc-\([^ ]*\) .*/\1/')
		local bson_version=$(pkg-config --list-all | sed -e '/^libbson-[0-9]/!d' -e 's/^libbson-\([^ ]*\) .*/\1/')

		myqmakeargs+=( "QX_BSON_INCLUDE_PATH=/usr/include/libbson-${bson_version}" 
							"QX_MONGOC_INCLUDE_PATH=/usr/include/libmongoc-${mongoc_version}" )
	fi

	eqmake5 "${myqmakeargs[@]}" QxOrm.pro

	sed -i \
			-e 's#-l /usr/lib64/libQt5Gui.so#-lQt5Gui -l#' \
			-e 's#-l /usr/lib64/libQt5Network.so#-lQt5Network -l#' \
			-e 's#-l /usr/lib64/libQt5Sql.so#-lQt5Sql -l#' \
			-e 's#-l /usr/lib64/libQt5Core.so#-lQt5Core#'\
			"${WORKDIR}"/qxorm-"${PV}"/Makefile.Debug

	sed -i \
			-e 's#-l /usr/lib64/libQt5Gui.so#-lQt5Gui -l#' \
			-e 's#-l /usr/lib64/libQt5Network.so#-lQt5Network -l#' \
			-e 's#-l /usr/lib64/libQt5Sql.so#-lQt5Sql -l#' \
			-e 's#-l /usr/lib64/libQt5Core.so#-lQt5Core#'\
			"${WORKDIR}"/qxorm-"${PV}"/Makefile.Release
}

src_install() {
	dolib.so lib/*

	doheader -r include/*

	insinto  /usr/include/inl
	doins -r inl/*
}
