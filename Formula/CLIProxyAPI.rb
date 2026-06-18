class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.18/CLIProxyAPI_7.2.18_darwin_aarch64.tar.gz"
      sha256 "b2c1051486085cffcc7b69a1f47e78ab902e96fb88c4ba0f5dc7bbd7344a7493"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.18/CLIProxyAPI_7.2.18_darwin_amd64.tar.gz"
      sha256 "f90b676db4a16a0ac6075fbe181ce617ce5bc2a1ae8c299f010d70b3889e5375"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.18/CLIProxyAPI_7.2.18_linux_aarch64.tar.gz"
      sha256 "af4d0816a20795470d99867c27d99f4cf95701d4c9dd09cc8445375bafb8d56a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.18/CLIProxyAPI_7.2.18_linux_amd64.tar.gz"
      sha256 "a358fb2da31e28f58ffe0cad65cc2c889f73ed8e79a93fe21752065d5be3fa53"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
