class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.50"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.50/CLIProxyAPI_7.2.50_darwin_aarch64.tar.gz"
      sha256 "2084aeed808fc9116eef92539bf6df95d76c06a6e0ecd45600a8fb9f2f65dc42"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.50/CLIProxyAPI_7.2.50_darwin_amd64.tar.gz"
      sha256 "65ab21cd7281ae58b2aded7a10045a2a5ff7d6c3dc004781ec65b699a41a7c3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.50/CLIProxyAPI_7.2.50_linux_aarch64.tar.gz"
      sha256 "b99fd1cd0a7e61feae381334ec75a25fb3a3629759ff26763b2a4ff0b57e0d80"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.50/CLIProxyAPI_7.2.50_linux_amd64.tar.gz"
      sha256 "a4cec2de62039b1a14c02c2e630ca2e22838f3201ad31f0975877d53d4add756"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
