# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake flag-o-matic

DESCRIPTION="A clean, light window manager"
HOMEPAGE="https://ctwm.org/"
SRC_URI="https://ctwm.org/dist/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	virtual/jpeg
	x11-base/xorg-proto
"

src_prepare() {
	# Fix bug 715904 on musl builds
	use elibc_musl && append-cflags -D_GNU_SOURCE
	cmake_src_prepare

	# implicit 'isspace'
	sed -i parse.c -e "/<stdio.h>/ a#include <ctype.h>" || die
}

src_configure() {
	local mycmakeargs=(
		-DNOMANCOMPRESS=yes
		-DDOCDIR=/usr/share/doc/${PF}
	)

	cmake_src_configure
}
