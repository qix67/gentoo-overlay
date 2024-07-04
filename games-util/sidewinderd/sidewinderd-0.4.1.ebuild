# Copyright 1999-2017 Gentoo Foundation         -*-Shell-script-*-
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Support for MS Sidewinder X4, X6 and Logitech G105, G710, G710+, G815"
HOMEPAGE="https://github.com/cornernote/sidewinderd"
#SRC_URI="https://github.com/cornernote/sidewinderd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/cornernote/sidewinderd/archive/refs/heads/g815-support.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-build/cmake-2.8.8
	>=dev-libs/libconfig-1.4.9
	>=dev-libs/tinyxml2-2.2.0
	virtual/libudev
"

RDEPEND="${DEPEND}"

RESTRICT="mirror"

function src_unpack {
    unpack ${A}
    mv `dirname ${S}`/${PN}-g815-support ${S}
}

function src_compile {
    mkdir -p build
    (cd build
     cmake -DCMAKE_INSTALL_PREFIX=/usr ..
     emake
    )
}

function src_install {
    (cd build
     emake DESTDIR="${D}" install
    )

    if ! declare -p DOCS &>/dev/null ; then
        local d
        for d in README* ChangeLog AUTHORS NEWS TODO CHANGES \
                         THANKS BUGS FAQ CREDITS CHANGELOG ; do
            if [[ -s "${d}" ]]; then
		dodoc "${d}"
	    fi
        done
    elif [[ $(declare -p DOCS) == "declare -a "* ]] ; then
        dodoc "${DOCS[@]}"
    else
        dodoc ${DOCS}
    fi

    local -r ETC=/etc

    newinitd "${FILESDIR}"/sidewinderd.1 sidewinderd

    insinto ${ETC}
    newins "${FILESDIR}"/sidewinderd.conf.1 sidewinderd.conf

    sed -i -e '/ExecStart=/s:$:'" -c ${ETC}/sidewinderd.conf -d:" \
	${ED}/usr/lib/systemd/system/sidewinderd.service
    
    elog "Please edit ${ETC}/sidewinderd.conf,"
    elog "then add sidewinderd to the default runlevel"
}
