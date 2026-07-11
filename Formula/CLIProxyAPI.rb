class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.66"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.66/CLIProxyAPI_7.2.66_darwin_aarch64.tar.gz"
      sha256 "88081d32009590369c33b5db8cf24012741a6632329db870f7891c35a1951daa"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.66/CLIProxyAPI_7.2.66_darwin_amd64.tar.gz"
      sha256 "63507b84fa7d2842af82bf691cac2c4a835d2b6aa0ea36d76d3e2e8aab43155b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.66/CLIProxyAPI_7.2.66_linux_aarch64.tar.gz"
      sha256 "062fe4507bda79820da067d5f4b3ffa2d014b88b7588687187953d4511d08739"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.66/CLIProxyAPI_7.2.66_linux_amd64.tar.gz"
      sha256 "67f25bd9b1d22b5f8f2da62813eb2dbfb2801ebe5d5f540e0aeaa99b31c05e49"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
