class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.19/CLIProxyAPI_7.3.19_darwin_aarch64.tar.gz"
      sha256 "558f72cc2b9b1593ae56e855bfa1ded9eb80cd734e95d9596bad5310fb5becef"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.19/CLIProxyAPI_7.3.19_darwin_amd64.tar.gz"
      sha256 "baeb8af2a62e475cecb4ff051d56546f2fa78cd44c2db6a7917cdde78de35d7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.19/CLIProxyAPI_7.3.19_linux_aarch64.tar.gz"
      sha256 "e3edd77e5a0c5a696220ecc9377a64a7888687112a2b90e07b0a09743c7bf821"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.19/CLIProxyAPI_7.3.19_linux_amd64.tar.gz"
      sha256 "7df503fe277e1e6902da9588f29f1b6fb0bf133ac7e4c25030712c6d70f6dac9"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
