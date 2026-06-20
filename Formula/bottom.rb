class Bottom < Formula
  desc "Cross-platform graphical system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  version "0.14.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.0/bottom_aarch64-apple-darwin.tar.gz"
      sha256 "fd9c24fa4ebba04ab97f01313a839232a2be7072a7237f71c5b9b0b0f12f4ff6"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.0/bottom_x86_64-apple-darwin.tar.gz"
      sha256 "060c19e21869512afc61ee369e2b468e7e80640f009697a375e1d04413194420"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.0/bottom_aarch64-linux-android.tar.gz"
      sha256 "ffea26cce1ff19fe9249046d87e8b53a86eb36251a3515fdd008652bbbf0918b"
    end
    on_intel do
      url "https://github.com/ClementTsang/bottom/releases/download/0.14.0/bottom_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6cd7be7183d64927ec2011a78e9bb865207196a398ecd67596c2a6e8812bca90"
    end
  end

  def install
    bin.install Dir["btm*"].first => "btm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btm --version 2>&1", 1)
  end
end
