class Zoxide < Formula
  desc "A smarter cd command — tracks your most used directories"
  homepage "https://github.com/ajeetdsouza/zoxide"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "b55ae6f2f5f23d0a6ccb3bd4eeb2af9c7e0a6556e5255c82100e40305129bbb0"
    end
    on_intel do
      url "https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "18ab7ae2633ad6e2ab79a4e665cbba1e95b7c872d44523326efb793202451dad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f1f16c5d6298d63dee467eedea1cdcd8490e43e493bea43acd416dc9033ef641"
    end
    on_intel do
      url "https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2d93385b99f3e82cf2701609a1bffcad863fbeb75aa3fe7eb6be4d29be68b1ae"
    end
  end

  def install
    bin.install Dir["zoxide*"].first => "zoxide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zoxide --version 2>&1", 1)
  end
end
