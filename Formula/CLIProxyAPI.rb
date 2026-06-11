class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.67"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.67/CLIProxyAPI_7.1.67_darwin_aarch64.tar.gz"
      sha256 "c14bb58373a32919f370403b5df12632e036c6ec06d3d212d80483c398720d39"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.67/CLIProxyAPI_7.1.67_darwin_amd64.tar.gz"
      sha256 "1b0828a48a8460b360df08695eb0c500688a23755f5d8fdf54a7b6fa530347d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.67/CLIProxyAPI_7.1.67_linux_aarch64.tar.gz"
      sha256 "e9a4ffc5c0787d87d8ebb09ca0b859c028ffe9e6c73a5fe48322ceefd18e2267"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.67/CLIProxyAPI_7.1.67_linux_amd64.tar.gz"
      sha256 "ceec510ad477a1c04115d9a09ad19b645a97fb4d53d06297ba5b101bc8582602"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
