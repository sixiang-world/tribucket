class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.79"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.79/CLIProxyAPI_7.2.79_darwin_aarch64.tar.gz"
      sha256 "e6f5786a6b688f2366d2ee4d23737e8dc8c3da98205ef78081554b3db7a59965"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.79/CLIProxyAPI_7.2.79_darwin_amd64.tar.gz"
      sha256 "bdc9e13b55902e165810cd1e7784088cc7a802d6291541687b311c09c50c2c10"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.79/CLIProxyAPI_7.2.79_linux_aarch64.tar.gz"
      sha256 "26b6e083982cb78bf8d8060ceb9ad993dec558c3e6dd2ca07f1d998655c667da"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.79/CLIProxyAPI_7.2.79_linux_amd64.tar.gz"
      sha256 "05488d45bd3f49892a60c36fc365f8d98c6177884aeccdca8626e0fb1adb4f0a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
