class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.47"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.47/CLIProxyAPI_8.0.47_darwin_aarch64.tar.gz"
      sha256 "a5b260ec0f843d2291488acd76e5595232da8f3b8ec2d334154f1570f5f3ca08"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.47/CLIProxyAPI_8.0.47_darwin_amd64.tar.gz"
      sha256 "2e72cb7b28905b9135563e4fc01af00009ce72a444729eb95bdb634543ce7d41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.47/CLIProxyAPI_8.0.47_linux_aarch64.tar.gz"
      sha256 "da1326ed4434fb6c9609927f317c093f9a4bb482a61e5451e9bea99a0dc7c4bf"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.47/CLIProxyAPI_8.0.47_linux_amd64.tar.gz"
      sha256 "2b5111dc6a0dfe0d607457787f794330d1b477bc9daa6337c26b0cd032a7827e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
