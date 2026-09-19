class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.8/CLIProxyAPI_7.3.8_darwin_aarch64.tar.gz"
      sha256 "4676f94066fae3b10fc16c8d181e893ef40075257b2ce581202ab978381ce293"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.8/CLIProxyAPI_7.3.8_darwin_amd64.tar.gz"
      sha256 "38099b7e0ad4792bfc449ccc0f5e9fd9feb9823e245c24691a3bca01d5a2b865"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.8/CLIProxyAPI_7.3.8_linux_aarch64.tar.gz"
      sha256 "8d09ce286d857b2d0e6d77c39e08a755246120df58c02a115d58c391fc73e3f1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.8/CLIProxyAPI_7.3.8_linux_amd64.tar.gz"
      sha256 "3fe5228c458624175d5e4e81d9dd003d82de688ca498fa368a790ea120bda0e3"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
