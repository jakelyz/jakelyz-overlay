# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic virtualx

DESCRIPTION="A clean, light window manager"
HOMEPAGE="https://ctwm.org/"
SRC_URI="https://ctwm.org/dist/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="jpeg rplay test xpm"
RESTRICT="!test? ( test )"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	jpeg? ( virtual/jpeg )
	rplay? ( media-sound/rplay )
	xpm? (x11-libs/libXpm )
"
DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	x11-base/xorg-proto
"

src_prepare() {
	use elibc_musl && append-cflags -D_GNU_SOURCE # Bug 715904
	cmake_src_prepare

	# implicit 'isspace'
	sed -i parse.c -e "/<stdio.h>/ a#include <ctype.h>" || die
}

src_configure() {
	local mycmakeargs=(
		-DNOMANCOMPRESS=yes
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DUSE_JPEG=$(usex jpeg ON OFF)
		-DUSE_RPLAY=$(usex rplay ON OFF)
		-DUSE_XPM=$(usex xpm ON OFF)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all
	use test && cmake_src_compile test_bins # Bug 701656
}

src_test() {
	virtx cmake_src_test
}
