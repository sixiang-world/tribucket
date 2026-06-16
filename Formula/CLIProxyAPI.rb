class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.11/CLIProxyAPI_7.2.11_darwin_aarch64.tar.gz"
      sha256 "f26c5e5ba0150c4e9d8817f1bb83d1c78ec7c5361a5177f1d05ba6a6301695e8"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.11/CLIProxyAPI_7.2.11_darwin_amd64.tar.gz"
      sha256 "bea03e2f3eb83f4a0dd5c0251824c0d72073711a3a0c9aa0edbfe692709e784d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.11/CLIProxyAPI_7.2.11_linux_aarch64.tar.gz"
      sha256 "7074e4d112ed3f80124147252d394bccc5c0cd760467b2213a78a77984eb1fbf"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.11/CLIProxyAPI_7.2.11_linux_amd64.tar.gz"
      sha256 "b31181cf88e85ba4b38e9a8350fe73fbb26132a9cd47fd76bd4df23fb0d4572a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
