class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.44"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.44/CLIProxyAPI_7.2.44_darwin_aarch64.tar.gz"
      sha256 "d4b00ebcd2fe6a9105b40306d37264ac4b9bdd54d107919321beb94bc062a702"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.44/CLIProxyAPI_7.2.44_darwin_amd64.tar.gz"
      sha256 "c1b6cd4ea09fd18fdc14b6ff3fc4cac8ac9878abde73a37d588a1ab56c73ee1b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.44/CLIProxyAPI_7.2.44_linux_aarch64.tar.gz"
      sha256 "b29eab4d52dc3e5ba84aefcaa53165e665f84572c0037995827e293b278421b3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.44/CLIProxyAPI_7.2.44_linux_amd64.tar.gz"
      sha256 "e927ba0b11846ddb576f69ff04935eb8b8058f92b4ab784ae5aeb57379bf027e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
