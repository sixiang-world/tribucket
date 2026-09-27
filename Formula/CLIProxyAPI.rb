class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.2/CLIProxyAPI_8.0.2_darwin_aarch64.tar.gz"
      sha256 "305424f9a67e12b1e0e37f772c0f960f946f0e3c385226ab481a12e50f0621ae"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.2/CLIProxyAPI_8.0.2_darwin_amd64.tar.gz"
      sha256 "7f5d192bd92fd06d24c5e286b673e3fbd0b05fee69983729cdb20792b5a857a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.2/CLIProxyAPI_8.0.2_linux_aarch64.tar.gz"
      sha256 "e790af5d63b6bd803c4173ef0d7dc8aaf8e5d66f822d28551c45fd5112918065"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.2/CLIProxyAPI_8.0.2_linux_amd64.tar.gz"
      sha256 "7478ab50f5b59cb34911547b2b527275bd0bf64f52687588dcce65a386f244ad"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
