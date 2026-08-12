class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.129"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.129/CLIProxyAPI_7.2.129_darwin_aarch64.tar.gz"
      sha256 "66c003f1eae50c9586b02fa6a6f76959241c13d242883ba400eafeab98fefea0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.129/CLIProxyAPI_7.2.129_darwin_amd64.tar.gz"
      sha256 "57ac8bc93e9f93358913701f156b39a4784c31f40a518a39b6fb2a85d6304114"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.129/CLIProxyAPI_7.2.129_linux_aarch64.tar.gz"
      sha256 "038965c9a550d053f81c36564ba486f64c9a2142f967195e55d28f48c28d8312"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.129/CLIProxyAPI_7.2.129_linux_amd64.tar.gz"
      sha256 "fbebc75dc9322fc25252eaabc4ee474babbd1d61f7845e6c002ccdd8f24c3818"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
