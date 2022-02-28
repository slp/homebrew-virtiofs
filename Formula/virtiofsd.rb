class Virtiofsd < Formula
  desc "Virtiofs daemon"
  homepage "https://gitlab.com/slp/virtiofsd"
  url "https://gitlab.com/slp/virtiofsd/-/archive/macos-poc/virtiofsd-macos-poc.tar.gz"
  version "1.1.0-macos"
  sha256 "796a0cfb10fb5ea4ca5c5f2e3499bfd9f681b79de04ef4d2acba40207e854b1c"
  license "Apache-2.0 OR BSD-3-Clause"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "virtiofsd", "--version"
  end
end
