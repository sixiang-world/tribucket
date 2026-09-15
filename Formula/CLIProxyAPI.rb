class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.4/CLIProxyAPI_7.3.4_darwin_aarch64.tar.gz"
      sha256 "42678f1ca09757dbdad0f71b2fb195be56b7575decabf2759b56aaeeacc773d6"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.4/CLIProxyAPI_7.3.4_darwin_amd64.tar.gz"
      sha256 "e538047560991bc4c70070d4f9929643325b898dcc8327041c5203e6717db966"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.4/CLIProxyAPI_7.3.4_linux_aarch64.tar.gz"
      sha256 "d452f100d76a7c68c5aa2c9da22a6a711a1ce55e910a3856b19eb23d0afd0397"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.4/CLIProxyAPI_7.3.4_linux_amd64.tar.gz"
      sha256 "48ded3538cccebc58918927e90ab91291d032df2e56bcf02b2b670b0912cbb21"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
