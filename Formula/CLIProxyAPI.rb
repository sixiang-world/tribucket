class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.56"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.56/CLIProxyAPI_8.0.56_darwin_aarch64.tar.gz"
      sha256 "356bb4c64d3ef0238192481be1d0efde6d495bba74bdefe60badbc5dce698799"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.56/CLIProxyAPI_8.0.56_darwin_amd64.tar.gz"
      sha256 "68a40da80b87c8e4d4e66453e04a44183767ea593e1070661ed92e3855558b51"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.56/CLIProxyAPI_8.0.56_linux_aarch64.tar.gz"
      sha256 "1bbe291232849f1707630d817d70c994cd1e9da40c070035b52d113683557f68"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.56/CLIProxyAPI_8.0.56_linux_amd64.tar.gz"
      sha256 "6f313dfdfbb62154de97a446cfc47d5a3419723484ea9f3bc1fb0a3015d195e7"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
