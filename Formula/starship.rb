class Starship < Formula
  desc "Cross-shell prompt customization"
  homepage "https://github.com/starship/starship"
  version "1.26.0"
  license "ISC"

  on_macos do
    on_arm do
      url "https://github.com/starship/starship/releases/download/v1.26.0/starship-aarch64-apple-darwin.tar.gz"
      sha256 "c40b27b11f580411e068f2fa6c1be7830a387c0bc47a94d1d37f32b054c5361d"
    end
    on_intel do
      url "https://github.com/starship/starship/releases/download/v1.26.0/starship-x86_64-apple-darwin.tar.gz"
      sha256 "5548f406a4b6f5695903bdea83f77ce47ec12c8c0e62dabd33122d8f133e4207"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/starship/starship/releases/download/v1.26.0/starship-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dc30189378d2f2e287384e8a692d3f95ad1df64cf0e8c36aa9201516028aed6b"
    end
    on_intel do
      url "https://github.com/starship/starship/releases/download/v1.26.0/starship-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "321f0dd7af8340a5f2e6a8fec6538a04f617486f9ec70d878f91c09cd8deef22"
    end
  end

  def install
    bin.install Dir["starship*"].first => "starship"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/starship --version 2>&1", 1)
  end
end
