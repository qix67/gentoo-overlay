# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils multilib versionator wxwidgets

DESCRIPTION="wxWidgets GUI for PostgreSQL"
HOMEPAGE="https://www.pgadmin.org/"
#SRC_URI="mirror://postgresql/pgadmin/pgadmin3/v${PV}/src/${P}.tar.gz"
#KEYWORDS="amd64 ppc x86 ~x86-fbsd"

EGIT_REPO_URI="https://github.com/AbdulYadi/pgadmin3.git"
inherit git-r3
DOCS=(); SRC_URI=""

LICENSE="POSTGRESQL"
SLOT="0"
IUSE="-debug +databasedesigner +zlib -openssl -gcrypt"

REQUIRED_USE="
	?? ( openssl gcrypt )
"

DEPEND="
	x11-libs/wxGTK:3.0=[X]
	>=dev-db/postgresql-12:=
	>=dev-libs/libxml2-2.9
	>=dev-libs/libxslt-1.1"
RDEPEND="${DEPEND}
	zlib? ( >=sys-libs/zlib-1.1.4 )
	openssl? ( >=dev-libs/openssl-1.1 )
	gcrypt? ( dev-libs/libgcrypt )
"

PATCHES=( "${FILESDIR}"/pgadmin3-{desktop-r1,gcc6-null-pointer}.patch )

src_prepare() {
	./bootstrap || die
	default
	eautoreconf
}

src_configure() {
	WX_GTK_VER="3.0"

	setup-wxwidgets

	econf --with-wx-version=${WX_GTK_VER} \
		$(use_enable debug) \
		$(use_with zlib libz) \
		$(use_with openssl openssl) \
		$(use_with gcrypt libgcrypt) \
		$(use_enable databasedesigner) \
		--with-sphinx-build=no
}

src_install() {
	emake DESTDIR="${D}" install

	newicon "${S}/pgadmin/include/images/pgAdmin3.png" ${PN}.png

	domenu "${S}/pkg/pgadmin3.desktop"

	# Fixing world-writable files
	fperms -R go-w /usr/share
}
