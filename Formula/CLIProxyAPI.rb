class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.142"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.142/CLIProxyAPI_7.2.142_darwin_aarch64.tar.gz"
      sha256 "dcf5786d6c55301ac3bb26dc3bed0fec2a71e568aecee6ce0c3c5aa4d1397bcd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.142/CLIProxyAPI_7.2.142_darwin_amd64.tar.gz"
      sha256 "2c8bf04f3039d77983e100cf4e972bb5f12f57d11cb270ac8561392616f536b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.142/CLIProxyAPI_7.2.142_linux_aarch64.tar.gz"
      sha256 "5ed65ca8f667995fb2d61421f74bf9eb08b7c46357ff5ce899b521728e86af77"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.142/CLIProxyAPI_7.2.142_linux_amd64.tar.gz"
      sha256 "a7cccc8f94b07660303c1874fb6bedae6d573a0f3c4c0b17ad8cf7885dd7a051"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
