class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.1/mise-v2026.9.1-macos-arm64.tar.gz"
      sha256 "bfea0ab417b48c1e8b99412fcaf20ce17424a3286a8766d7d2b0051fe321d565"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.1/mise-v2026.9.1-macos-x64.tar.gz"
      sha256 "eed76838c68aa49b7bf07c468dd4993855bbb342a4442f67355b6ffbe746e4d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.1/mise-v2026.9.1-linux-arm64.tar.gz"
      sha256 "98d2ea7b82dd966afdb8a9f4e9edbca771acf2a30d2842bfc0efdb7b61c886a3"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.1/mise-v2026.9.1-linux-x64.tar.gz"
      sha256 "063dda9149ab6be53da877c2d176afe0eac68e64cf8ca295bd0528720701c65d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
