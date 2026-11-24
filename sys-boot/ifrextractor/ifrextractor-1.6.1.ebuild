EAPI=8

inherit cargo

DESCRIPTION="Rust utility to extract UEFI IFR data into human-readable text"
HOMEPAGE="https://github.com/LongSoft/IFRExtractor-RS"
SRC_URI="https://github.com/LongSoft/IFRExtractor-RS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

S="${WORKDIR}/IFRExtractor-RS-${PV}"

CRATES="
async-trait-0.1.89
block-buffer-0.10.4
bytes-1.11.1
cfg-if-1.0.4
cpufeatures-0.2.17
crypto-common-0.1.7
digest-0.10.7
generic-array-0.14.7
hex-0.4.3
libc-0.2.183
memchr-2.5.0
nom-4.2.3
pin-project-lite-0.2.17
proc-macro2-1.0.106
quote-1.0.45
sha2-0.10.9
sha256-1.6.0
syn-2.0.117
tokio-1.50.0
typenum-1.19.0
unicode-ident-1.0.24
version_check-0.1.5
version_check-0.9.5
"

SRC_URI+=" $(cargo_crate_uris)"

src_configure() {
	cargo_src_configure
}

src_compile() {
	cargo_src_compile
}

src_install() {
	dobin "$(cargo_target_dir)/ifrextractor"
}
