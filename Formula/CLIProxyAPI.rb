class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.89"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.89/CLIProxyAPI_7.2.89_darwin_aarch64.tar.gz"
      sha256 "26e07b40668d0c15ab022137373e493bb6441d5e2d222de38c9dc7507753a777"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.89/CLIProxyAPI_7.2.89_darwin_amd64.tar.gz"
      sha256 "b7d83cdc9894da08fb44f16d2f26ad482cbb891da943471caa8817b9ad74f633"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.89/CLIProxyAPI_7.2.89_linux_aarch64.tar.gz"
      sha256 "c7bc4373f74391d5f42af62456ac4b778a222a7f32fd39cbe9a73d54bd449b3f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.89/CLIProxyAPI_7.2.89_linux_amd64.tar.gz"
      sha256 "a4191bebb2fea7c0987645e1f317a026cd560a11ca782817f89d23006cf23762"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
