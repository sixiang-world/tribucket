class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.17/CLIProxyAPI_7.3.17_darwin_aarch64.tar.gz"
      sha256 "59bca8a23938216eab42380362424a109986df20c70d5f552948d3dfeb3c7820"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.17/CLIProxyAPI_7.3.17_darwin_amd64.tar.gz"
      sha256 "37f6b9767d2820d96095f5a792041b6c11dcd7420023aa2c3fe1769aaeff6612"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.17/CLIProxyAPI_7.3.17_linux_aarch64.tar.gz"
      sha256 "65a250f749222eee88d949e94efd88c9a9640728e01ae83e1353bac591487e3f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.17/CLIProxyAPI_7.3.17_linux_amd64.tar.gz"
      sha256 "1c9aef78dcd372775ccd5252bd0f383366c93c1fa552204df8ea9191fa130927"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
