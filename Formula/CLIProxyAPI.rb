class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.19/CLIProxyAPI_7.2.19_darwin_aarch64.tar.gz"
      sha256 "9e72695f3237eb425a7f3b4d4ac23b44c7b35ba814d1b0b21e783838a31dc184"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.19/CLIProxyAPI_7.2.19_darwin_amd64.tar.gz"
      sha256 "d87a584f66f87345af5bc4360b8eb0e4dfeedecd38fc3828d66171ba0fcc5397"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.19/CLIProxyAPI_7.2.19_linux_aarch64.tar.gz"
      sha256 "112d1fc19e9032d6ac965f127e6d6358018689ae96f609c7de31f5acb2cefdf7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.19/CLIProxyAPI_7.2.19_linux_amd64.tar.gz"
      sha256 "b301f5004f794d6b6bfef93b1781730c6da70c4acdb20c9192a778dfbe1baa68"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
