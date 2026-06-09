class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.59"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.59/CLIProxyAPI_7.1.59_darwin_aarch64.tar.gz"
      sha256 "c1adf2d92d00fe3b8eb9ff44ab546c444b53d429bf63bd17eecbf257a4bc6fe4"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.59/CLIProxyAPI_7.1.59_darwin_amd64.tar.gz"
      sha256 "8738c9b577def78729b2645a631119ac6b928572a2e9257d2a949ddcc329b463"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.59/CLIProxyAPI_7.1.59_linux_aarch64.tar.gz"
      sha256 "1820cd34b1e2a518158bf81c8a8919b91bf0864f5fb189d1b65d80430e650cdd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.59/CLIProxyAPI_7.1.59_linux_amd64.tar.gz"
      sha256 "cb8095513f99d3f8fa790ccfc0ef097b03ceb4ad87b6ae508b548dfcfdd8fc06"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
