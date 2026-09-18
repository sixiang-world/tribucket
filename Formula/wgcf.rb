class Wgcf < Formula
  desc "Cross-platform unofficial CLI for Cloudflare Warp"
  homepage "https://github.com/ViRb3/wgcf"
  version "2.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.0/wgcf_2.3.0_darwin_arm64"
      sha256 "852d7fc7b74a5f9dca54c7cbd49068689aead71fe8f42f4af74eb9429cf87642"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.0/wgcf_2.3.0_darwin_amd64"
      sha256 "54aac2497c1fd6ef9a90d13d18b8e1f16f043ee4907d189d7dd5c9f32cf462f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.0/wgcf_2.3.0_linux_arm64"
      sha256 "dcadadc42bcc410a4032a6d1c0490ea510e199f0aaaee397dc1aa0fbd27038e8"
    end
    on_intel do
      url "https://github.com/ViRb3/wgcf/releases/download/v2.3.0/wgcf_2.3.0_linux_amd64"
      sha256 "01614e38c0eb5f3405232e71cfaf02d64d4809e4988ad8f5a8071af16d193405"
    end
  end

  def install
    bin.install Dir["wgcf*"].first => "wgcf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wgcf --version 2>&1", 1)
  end
end
