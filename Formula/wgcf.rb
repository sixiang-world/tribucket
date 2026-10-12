class Wgcf < Formula
  desc "Cross-platform unofficial CLI for Cloudflare Warp"
  homepage "https://github.com/ViRb3/wgcf"
  version "2.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.1/wgcf_2.3.1_darwin_arm64"
      sha256 "45be8d5ea91fd0b938a1775fd3e0b29a33b756b6cc67a0a9f305bcf86ff608c2"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.1/wgcf_2.3.1_darwin_amd64"
      sha256 "de295a28dd7503cd779c9afa2bf2e59435107bace94bdc0b57b66d8c9d9408ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.1/wgcf_2.3.1_linux_arm64"
      sha256 "710ab2d8ac145d81a4cf0c11bdb0e05914f77ae2a45f67b87e718d84b4cb7301"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.1/wgcf_2.3.1_linux_amd64"
      sha256 "4fb7a136aa470ece11d17949c7db07b040ec9c604742dc8680bcf1889f85d0c8"
    end
  end

  def install
    bin.install Dir["wgcf*"].first => "wgcf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wgcf --version 2>&1", 1)
  end
end
