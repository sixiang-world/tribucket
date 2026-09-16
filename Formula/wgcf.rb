class Wgcf < Formula
  desc "Cross-platform unofficial CLI for Cloudflare Warp"
  homepage "https://github.com/ViRb3/wgcf"
  version "2.2.32"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.32/wgcf_2.2.32_darwin_arm64"
      sha256 "6c19e27eefade597f3778f5fdcbd0a5f5297e9ff343cbb44cc206e21d83d48fb"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.32/wgcf_2.2.32_darwin_amd64"
      sha256 "5d977de53c171cfd4fa07ea281ceb89e424c8d643bd9e3263be22820f15ce84b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.32/wgcf_2.2.32_linux_arm64"
      sha256 "21fe21d9f61db9b381d71200f6f59c7949e0bb455446edcb33dda6ad6a8fcf8f"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.2.32/wgcf_2.2.32_linux_amd64"
      sha256 "2ff97f2201972ce582a424455d50a3719a380eef0cd1f3144f7779348e122a2c"
    end
  end

  def install
    bin.install Dir["wgcf*"].first => "wgcf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wgcf --version 2>&1", 1)
  end
end
