class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.5/mise-v2026.11.5-macos-arm64.tar.gz"
      sha256 "f69c8a4f7c265d5f3ffdd06d44104aa15a7ffd9b6545a87b7768f893b70f0fd8"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.5/mise-v2026.11.5-macos-x64.tar.gz"
      sha256 "67f980425c594e59675027d8b522901dee80a94bafadcdc4dfdcce14f0cc3b40"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.5/mise-v2026.11.5-linux-arm64.tar.gz"
      sha256 "146b114c2714f6ed76a629778f162d578e14821e47b87389dbdd64068bd5cf06"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.5/mise-v2026.11.5-linux-x64.tar.gz"
      sha256 "d7dee029352bf4b8986e7c4696b8ce54746c3eb648ffca3cc69bdeecc0ff06e9"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
