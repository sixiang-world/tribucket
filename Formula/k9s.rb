class K9s < Formula
  desc "Terminal UI for managing Kubernetes clusters"
  homepage "https://github.com/derailed/k9s"
  version "0.51.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/derailed/k9s/releases/download/v0.51.0/k9s_Darwin_arm64.tar.gz"
      sha256 "9b8c0e8f461e5d33aeee43a67f5ef4aff646a008a786887b8266cbb153c610cc"
    end
    on_intel do
      url "https://github.com/derailed/k9s/releases/download/v0.51.0/k9s_Darwin_amd64.tar.gz"
      sha256 "7e8802c57c45a0cd389e8fc38472243fe4cf48d8ad5957e189ce370e19e5eda0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/derailed/k9s/releases/download/v0.51.0/k9s_Linux_arm64.tar.gz"
      sha256 "3ee05c82e5f9198928a4e86133608ba6a2c10a2244d6a7789e820f78319d640c"
    end
    on_intel do
      url "https://github.com/derailed/k9s/releases/download/v0.51.0/k9s_Linux_amd64.tar.gz"
      sha256 "c3752ad51a5a4015a113819c4eeb6e55a4d0e4b8e652494797532f6fc8161dd7"
    end
  end

  def install
    bin.install Dir["k9s*"].first => "k9s"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/k9s --version 2>&1", 1)
  end
end
