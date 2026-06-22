class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.28"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.28/CLIProxyAPI_7.2.28_darwin_aarch64.tar.gz"
      sha256 "51140ea770eb7eef029462d03b999cc53426a29bd7c0e205fb3cd37e8624a366"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.28/CLIProxyAPI_7.2.28_darwin_amd64.tar.gz"
      sha256 "edf1f6e89331776e143d2bd3906e057b98a0c9b5b0ac5e646003b909625c64f5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.28/CLIProxyAPI_7.2.28_linux_aarch64.tar.gz"
      sha256 "3f228d3220eee8a6c8b15ffa5aff98480dc5c38631598175001007e203864add"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.28/CLIProxyAPI_7.2.28_linux_amd64.tar.gz"
      sha256 "f33092832b32d2a3d8088fb1d2b5c8450d85cf2231c435dc7fb2c05c71e78bc7"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
