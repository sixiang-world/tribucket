class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.151"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.151/CLIProxyAPI_7.2.151_darwin_aarch64.tar.gz"
      sha256 "9115b9691ceff071735ec1365c2885dca5d4084105de09877f5afdb675f1f815"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.151/CLIProxyAPI_7.2.151_darwin_amd64.tar.gz"
      sha256 "05d9344b0a39b81ef1d4217b1136964dadfba4a485d18a70564562fef4f6bf98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.151/CLIProxyAPI_7.2.151_linux_aarch64.tar.gz"
      sha256 "14c03fcc69923c012bd0dace189790cf1ad1586f17bb64d8c09784a0a23ad587"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.151/CLIProxyAPI_7.2.151_linux_amd64.tar.gz"
      sha256 "194f38ad40bba5cb07cdc1521b0853be0f9868c53ade40c677f32b21005c33f9"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
