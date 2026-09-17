class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.7/CLIProxyAPI_7.3.7_darwin_aarch64.tar.gz"
      sha256 "15269902173e99b834b8577a520ddf8f89fbb4a224afd2230384c1890b06875f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.7/CLIProxyAPI_7.3.7_darwin_amd64.tar.gz"
      sha256 "7b20a8988afe1dff0a5f3cd3d7fd30300576d630506d747e74ce25dfc46bb2af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.7/CLIProxyAPI_7.3.7_linux_aarch64.tar.gz"
      sha256 "442aad130260cc22a75d2b230826e0b2185e92baf5ef8ae57b849ae694dddf2a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.7/CLIProxyAPI_7.3.7_linux_amd64.tar.gz"
      sha256 "3391dff672abccffce5f9259b7ce1e12cee7b0a8aa3f5b2280406484f59f37ba"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
