class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.0/mise-v2026.10.0-macos-arm64.tar.gz"
      sha256 "e6a966e44f871403df905d50019ca6f7b84624ddfe1d5c095f5bc3f18709259e"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.0/mise-v2026.10.0-macos-x64.tar.gz"
      sha256 "6bb6c2239b8990c81350d4f9e46bfffd6cfaf48f967b2f98963ce24b944400f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.0/mise-v2026.10.0-linux-arm64.tar.gz"
      sha256 "107c5e46693cdfeb1fdec91717078b298d6fcc9ebbd14f8333917cfe37965138"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.0/mise-v2026.10.0-linux-x64.tar.gz"
      sha256 "6ae3d2bda39cca86713501317edf623b59b75cd8afa2e31c20b1ee6500b4b739"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
