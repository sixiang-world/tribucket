class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.42"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.42/CLIProxyAPI_7.2.42_darwin_aarch64.tar.gz"
      sha256 "ccda46e5d33e8f711968bdd5066640de56492234e58f34645286d1deb4ccd761"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.42/CLIProxyAPI_7.2.42_darwin_amd64.tar.gz"
      sha256 "d29c9233a3f28e0c3accba7e966ebc2a710eedfa96ec422f51c6596d3c3d29c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.42/CLIProxyAPI_7.2.42_linux_aarch64.tar.gz"
      sha256 "16eac31652ece1d19e95ff9d3eff5a2f5e582e4c9d084988c415dbcf27a6f9e0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.42/CLIProxyAPI_7.2.42_linux_amd64.tar.gz"
      sha256 "53e4a196781fce7f6a5f5880ecedeef7f124e721a5fcb8ed8da3cb788991fc58"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
