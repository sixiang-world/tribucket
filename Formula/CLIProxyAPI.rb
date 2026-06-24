class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.35"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.35/CLIProxyAPI_7.2.35_darwin_aarch64.tar.gz"
      sha256 "4fef41ba997096f0a5ff55972af44577d4e3e4267cdaa15356a6843c53473e0a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.35/CLIProxyAPI_7.2.35_darwin_amd64.tar.gz"
      sha256 "61bfa25deccd0a345753ee340734117e49d7df31c40d5c1c9e98bf9c1a9472b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.35/CLIProxyAPI_7.2.35_linux_aarch64.tar.gz"
      sha256 "a2fcd3fb3722aaad0724d8ff638d8b32261aa918ccae3fe3ca592f8d70d5fa7d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.35/CLIProxyAPI_7.2.35_linux_amd64.tar.gz"
      sha256 "e748c40fdaeacb9537e33a30e92d64dff696cdb4541c8f3c12d1bb8f39c6844a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
