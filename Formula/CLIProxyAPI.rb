class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.83"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.83/CLIProxyAPI_7.2.83_darwin_aarch64.tar.gz"
      sha256 "1843e50b9966893ba1728ebf361c7ea5ed7ccebfe681c4f32409c638d70d77d4"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.83/CLIProxyAPI_7.2.83_darwin_amd64.tar.gz"
      sha256 "1f717de6b35bd7e4763f8de80b210bb7709d1ac162c0db161e14bb3d6c2ecea1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.83/CLIProxyAPI_7.2.83_linux_aarch64.tar.gz"
      sha256 "f7a865dd589354d922f46d1d436a659de27d6ceeabc83bb91e6430458b0a2746"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.83/CLIProxyAPI_7.2.83_linux_amd64.tar.gz"
      sha256 "7370fb5d39ffdd884f799d2609138b5465e29f49883ee6b521adee9af2138088"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
