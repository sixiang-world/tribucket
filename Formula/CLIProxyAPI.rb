class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.37"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.37/CLIProxyAPI_7.2.37_darwin_aarch64.tar.gz"
      sha256 "b9c9b14d91eed47096877cf169dafeb1d3a5f32df73832e7b2eab250c74eff6c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.37/CLIProxyAPI_7.2.37_darwin_amd64.tar.gz"
      sha256 "1d17e59b22711207437e23b8b076593a3ac7ced689cecaa63c7134919e87460e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.37/CLIProxyAPI_7.2.37_linux_aarch64.tar.gz"
      sha256 "a3ba79c9fa01eb5851e6678d27d691e6068674ab8da1565ea77313ba28fef484"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.37/CLIProxyAPI_7.2.37_linux_amd64.tar.gz"
      sha256 "1d13a0a4eae60805ddc46d40137e3e1ba9f1733cdb7b1224f38bc804712261d6"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
