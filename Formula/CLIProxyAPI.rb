class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.105"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.105/CLIProxyAPI_7.2.105_darwin_aarch64.tar.gz"
      sha256 "641de855c486d373b3c69704bec55a5c5ce3efa523149cc9bd253f76040470d7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.105/CLIProxyAPI_7.2.105_darwin_amd64.tar.gz"
      sha256 "c9332b8401cd54d357e7c66e88bce603fdb497701a7fa86ee2f82bb1aad846b9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.105/CLIProxyAPI_7.2.105_linux_aarch64.tar.gz"
      sha256 "b72245cf1958251330eae9e17f1fc5a077f94146b2eea30e23ab5012c6059981"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.105/CLIProxyAPI_7.2.105_linux_amd64.tar.gz"
      sha256 "f432872815fe85ac4b0f83b5598253725eea70aae4c95025194cf558f6acef31"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
