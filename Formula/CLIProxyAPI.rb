class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.67"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.67/CLIProxyAPI_7.2.67_darwin_aarch64.tar.gz"
      sha256 "6bbbe31dd951a394d7ef261fc6e9a5900ad746fcd5a1b571749e0ff33ff1b32d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.67/CLIProxyAPI_7.2.67_darwin_amd64.tar.gz"
      sha256 "fbc24c53b121c2520bbffadd8f653f353c2e01b0ea79717e3602db9ecd38167d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.67/CLIProxyAPI_7.2.67_linux_aarch64.tar.gz"
      sha256 "e0351aef42a9c0ed3240a725889f20743dcfa1e3b48f5295eddc78869943aa6b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.67/CLIProxyAPI_7.2.67_linux_amd64.tar.gz"
      sha256 "d3914c1db40ec3bdb9ee551bbdd0a4de17a59ac0f3bcdadeb43eb246b4ceaa50"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
