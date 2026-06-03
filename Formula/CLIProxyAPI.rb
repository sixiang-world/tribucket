class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.44"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.44/CLIProxyAPI_7.1.44_darwin_aarch64.tar.gz"
      sha256 "e3ccc1415e65544ef077ab79a73a85b4bf6da5535f9856bad8c87303cfd6312f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.44/CLIProxyAPI_7.1.44_darwin_amd64.tar.gz"
      sha256 "283f7b8575ece506c72c89b73f44c5ecf5b941b4e34f66b592a1b96247ac6230"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.44/CLIProxyAPI_7.1.44_linux_aarch64.tar.gz"
      sha256 "aef9d2c2e59b80a0d5ce4b3ed777380ef587664702e1c783091e2ba44089cd60"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.44/CLIProxyAPI_7.1.44_linux_amd64.tar.gz"
      sha256 "5d51e090ed6ceb695ba16fe8d9cdb7cb63d87ceaf212e2c3e87c3c06a4a1b8d2"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
