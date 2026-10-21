class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.37"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.37/CLIProxyAPI_8.0.37_darwin_aarch64.tar.gz"
      sha256 "7f2432cf34e587bc0e49e8e96247e797928dc6219b5f76b6f2b85835bd64c42f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.37/CLIProxyAPI_8.0.37_darwin_amd64.tar.gz"
      sha256 "c792421f6ca47610b1969ca026f21ef6c483cc5f52911ce8b2b2104a3fb4b515"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.37/CLIProxyAPI_8.0.37_linux_aarch64.tar.gz"
      sha256 "9a3a37cd083ebd3eb7b60295fdf301dd8cbb28e18d9503431c015b3153e52549"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.37/CLIProxyAPI_8.0.37_linux_amd64.tar.gz"
      sha256 "5fabb7ea9503f823e3a97fef613382422443585fe2b20e5de2bb43f41f90debc"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
