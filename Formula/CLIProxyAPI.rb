class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.32"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.32/CLIProxyAPI_7.2.32_darwin_aarch64.tar.gz"
      sha256 "2aa2f813a50231af3707453feac08e142810bb6b83c9d8e66068bf9ad99a3bd0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.32/CLIProxyAPI_7.2.32_darwin_amd64.tar.gz"
      sha256 "c51231f934687980a64171406bedbfd798a002f22a60f6cc0233ffd89837b7ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.32/CLIProxyAPI_7.2.32_linux_aarch64.tar.gz"
      sha256 "57941c5404fe720f178da088618f1c41dccf9ae3236ef4280b970c2927ea4070"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.32/CLIProxyAPI_7.2.32_linux_amd64.tar.gz"
      sha256 "f3c2168112101eb92fe3977374b04653d8a83a4658b2d46e61bcc8616920a69a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
