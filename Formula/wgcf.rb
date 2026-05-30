class Wgcf < Formula
  desc "Cross-platform unofficial CLI for Cloudflare Warp"
  homepage "https://github.com/ViRb3/wgcf"
  version "2.2.31"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.31/wgcf_2.2.31_darwin_arm64"
      sha256 "e4da91bf430d9e6109b28f8912cd2c7db8fe52eefa7519c385ab63caacf7915b"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.31/wgcf_2.2.31_darwin_amd64"
      sha256 "4df5b47890baa9131c32914827d6842c43d8cea51c08bce39ddaf3d6cf01310e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.31/wgcf_2.2.31_linux_arm64"
      sha256 "b9bdbdeaa3f9f4ba741ba55b8bd94c24f7166c27668eb7e8192ccf9746961182"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.31/wgcf_2.2.31_linux_amd64"
      sha256 "69147e1a517c66129edd8ac8cb60484d6c9515178d7b4a2f95e3c925f225572a"
    end
  end

  def install
    bin.install Dir["wgcf*"].first => "wgcf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wgcf --version 2>&1", 1)
  end
end
