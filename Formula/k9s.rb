class K9s < Formula
  desc "Terminal UI for managing Kubernetes clusters"
  homepage "https://github.com/derailed/k9s"
  version "0.50.18"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/derailed/k9s/releases/download/v0.50.18/k9s_Darwin_arm64.tar.gz"
      sha256 "68ff1541c60620466989019e86101805c1b6c70a746b1561261a403801f7fd48"
    end
    on_intel do
      url "https://github.com/derailed/k9s/releases/download/v0.50.18/k9s_Darwin_amd64.tar.gz"
      sha256 "80f3e30767ad3603bec9664db019e85f94493aa741d7755553ee6e47876df30e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/derailed/k9s/releases/download/v0.50.18/k9s_Linux_arm64.tar.gz"
      sha256 "d3dcc051d6be26ee911c00f583412802ebe203a189e51bc079332cb410c83b38"
    end
    on_intel do
      url "https://github.com/derailed/k9s/releases/download/v0.50.18/k9s_Linux_amd64.tar.gz"
      sha256 "0b697ed4aa80997f7de4deeed6f1fba73df191b28bf691b1f28d2f45fa2a9e9b"
    end
  end

  def install
    bin.install Dir["k9s*"].first => "k9s"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/k9s --version 2>&1", 1)
  end
end
