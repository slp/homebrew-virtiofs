class QemuVhost < Formula
  desc "QEMU with vhost-user support"
  homepage "https://www.qemu.org/"
  url "https://github.com/slp/qemu/releases/download/v6.2.50-vuf/qemu-6.2.50-vuf.tgz"
  version "6.2.50-vuf"
  sha256 "367e9a0e691103c749810e1eba15103a5a1662b163f0d2c5c665cced32c55e88"
  license "GPL-2.0-only"

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "qemu"
  depends_on "snappy"
  depends_on "vde"

  fails_with gcc: "5"

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --target-list=aarch64-softmmu,x86_64-softmmu
      --disable-tools
      --disable-bsd-user
      --disable-guest-agent
      --enable-curses
      --enable-libssh
      --enable-slirp=system
      --enable-vde
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --disable-sdl
      --disable-gtk
      --enable-cocoa
      --enable-vhost-user
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    system "./configure", *args
    system "make", "V=1"
    bin.mkdir
    cp "build/qemu-system-aarch64", bin/"qemu-vhost-aarch64"
    cp "build/qemu-system-x86_64", bin/"qemu-vhost-x86_64"
  end
end
