class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.51"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.51/CLIProxyAPI_8.0.51_darwin_aarch64.tar.gz"
      sha256 "fb8e2568e98e3304a1b892c4f70a4c154c661078ad87007e63cf7ba71b4ce168"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.51/CLIProxyAPI_8.0.51_darwin_amd64.tar.gz"
      sha256 "7f68be928979c3991d097255fd8fb732edc684e72fe10faf29a365e44246cedb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.51/CLIProxyAPI_8.0.51_linux_aarch64.tar.gz"
      sha256 "411aa08783c572bdb72a6ba0ffcc0a75155be27e75a1c5aef3b49d8b96da4d52"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.51/CLIProxyAPI_8.0.51_linux_amd64.tar.gz"
      sha256 "15de160e1fd97a0f9f7e0577582c765b14e040ab6a8314f514af9fae8a2c4700"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
