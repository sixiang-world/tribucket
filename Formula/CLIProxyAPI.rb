class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.4/CLIProxyAPI_8.0.4_darwin_aarch64.tar.gz"
      sha256 "2f06c4e0786cb61f15484eaf22efa7b6324ec20679b9113cfa9b95ccf75a73f1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.4/CLIProxyAPI_8.0.4_darwin_amd64.tar.gz"
      sha256 "ab60f62cfd55098ed42ae12733151d177e598637746b880918c05040d9ddfc8b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.4/CLIProxyAPI_8.0.4_linux_aarch64.tar.gz"
      sha256 "5d96ee2829734d525d7c7c8e4e21e3499ce39d5f452f47b7e6c231caa5eb4fae"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.4/CLIProxyAPI_8.0.4_linux_amd64.tar.gz"
      sha256 "f396653cd60cd20494705c22193d11878dce101687bb7d060871c163a5735bb6"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
