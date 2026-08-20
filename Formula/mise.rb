class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.9/mise-v2026.8.9-macos-arm64.tar.gz"
      sha256 "cab126b8b1b41b444a0dc1ebca54a9b1da5a529368b47faf0e6e4a1d272f183f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.9/mise-v2026.8.9-macos-x64.tar.gz"
      sha256 "b75a72261dd415decb39b82892b12085c8da5b0361f32aa4685c3d0f79c442e0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.9/mise-v2026.8.9-linux-arm64.tar.gz"
      sha256 "e289909e414bad0929172443bb99056867e933b858964b36bbed1c5f6e81b92b"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.9/mise-v2026.8.9-linux-x64.tar.gz"
      sha256 "790c3ea7fe7e97572aef0ca9b27c09aad162e0ffa85d70797cc3da24b8e1cea6"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
