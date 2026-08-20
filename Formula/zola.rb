class Zola < Formula
  desc "A fast static site generator in a single binary with everything built-in"
  homepage "https://github.com/getzola/zola"
  version "0.23.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.4/zola-v0.23.4-aarch64-apple-darwin.tar.gz"
      sha256 "303b8e1f3251a6250e47f811eda143316f653c22201faa66777d48ac499c0ee3"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.4/zola-v0.23.4-x86_64-apple-darwin.tar.gz"
      sha256 "e79edcba2e8d03d22065c9cb8fa2e3abf07b823ef17f00abdc060188dceabba7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.4/zola-v0.23.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "21bb37a4f3bbac663cf8f04df9b51ac6bc154acfe2cf2c3e9ea162b4951487b6"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.4/zola-v0.23.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "54d1a347781b2f32330914fcc02def81c7e3ddb6111b36d1cc89c06557aed1de"
    end
  end

  def install
    bin.install Dir["zola*"].first => "zola"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zola --version 2>&1", 1)
  end
end
