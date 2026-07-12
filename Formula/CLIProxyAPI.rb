class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.71"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.71/CLIProxyAPI_7.2.71_darwin_aarch64.tar.gz"
      sha256 "f8cd1028c591bcb89fdb15650457ae6a56e462346d7cf108a9f02dcb819196dd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.71/CLIProxyAPI_7.2.71_darwin_amd64.tar.gz"
      sha256 "1b8d4a969c952397764188e53d0b23249f484cb62043c83a534cfaea7d7d5ab0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.71/CLIProxyAPI_7.2.71_linux_aarch64.tar.gz"
      sha256 "fa49b1a0d1b88bab65558299156a35cac9025ff0bf73fbfc95ecf2644d393488"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.71/CLIProxyAPI_7.2.71_linux_amd64.tar.gz"
      sha256 "3201240a435c073acd77a7178c658838d750a57e79254b3850db81d8eb90b500"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
