class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.54"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.54/CLIProxyAPI_7.1.54_darwin_aarch64.tar.gz"
      sha256 "43b72d5622b0799fad4bdbfffb0b96f3ff6507b0cad73fbe2abba0d9e0366f8b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.54/CLIProxyAPI_7.1.54_darwin_amd64.tar.gz"
      sha256 "a0424a00e281c19c937a956f96c0f4bb8773d879f9385864e3854d437b87f0f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.54/CLIProxyAPI_7.1.54_linux_aarch64.tar.gz"
      sha256 "d49163d6fbc1c3dbf2c4e20366c803d0a82659b0f8d9e7d41b2dd618e45dc93b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.54/CLIProxyAPI_7.1.54_linux_amd64.tar.gz"
      sha256 "0598a308dfaf334038bbb20f8124e16406f858d8b8802e531611b1de82117d00"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
