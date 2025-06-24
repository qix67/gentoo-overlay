# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

WX_GTK_VER="3.2-gtk3"

#CMAKE_IN_SOURCE_BUILD=yes

inherit autotools multilib wxwidgets git-r3 desktop cmake

DESCRIPTION="wxWidgets GUI for PostgreSQL"
HOMEPAGE="https://www.pgadmin.org/"
#SRC_URI="mirror://postgresql/pgadmin/pgadmin3/v${PV}/src/${P}.tar.gz"
#KEYWORDS="amd64 ppc x86 ~x86-fbsd"

EGIT_REPO_URI="https://github.com/levinsv/pgadmin3.git"
DOCS=(); SRC_URI=""

LICENSE="POSTGRESQL"
SLOT="0"
IUSE="-debug +databasedesigner +zlib -openssl -gcrypt"

REQUIRED_USE="
	?? ( openssl gcrypt )
"

DEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	>=dev-db/postgresql-15:=
	>=dev-libs/libxml2-2.9
	>=dev-libs/libxslt-1.1
	>=dev-build/cmake-3.2
	virtual/pkgconfig"
RDEPEND="${DEPEND}
	zlib? ( >=sys-libs/zlib-1.1.4 )
	openssl? ( >=dev-libs/openssl-1.1 )
	gcrypt? ( dev-libs/libgcrypt )
"

#PATCHES=( "${FILESDIR}"/pgadmin3-{desktop-r1,gcc6-null-pointer}.patch )

#src_prepare() {
	#PGSQL_VER=$(pkgconf --modversion libpq | sed 's/\..*//')

	##if [ "$PGSQL_VER" > 12 ]
	##then
		##eapply "${FILESDIR}/pg13.patch"
	##fi

	##./bootstrap || die
	#default
	#eautoreconf
#}

src_configure() {
	CXXFLAGS="-DNO_WXJSON_GIT" cmake_src_configure
}

src_install() {
	newicon "${S}/include/images/pgAdmin3.png" ${PN}.png

	domenu "${FILESDIR}/pgadmin3.desktop"

	exeinto "/usr/bin"
	doexe "${BUILD_DIR}/pgAdmin3"

	# Fixing world-writable files
	fperms -R go-w /usr/share
}
