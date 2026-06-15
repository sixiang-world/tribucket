class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.4/CLIProxyAPI_7.2.4_darwin_aarch64.tar.gz"
      sha256 "70534af799c517e4e9909d03cff1ec5ca5ac1bee7c2e949af831c29bbf6beb9c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.4/CLIProxyAPI_7.2.4_darwin_amd64.tar.gz"
      sha256 "b129d58014bc6397a55c8dff0a06481798047c77b73888e026aa94b9ce29a369"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.4/CLIProxyAPI_7.2.4_linux_aarch64.tar.gz"
      sha256 "4f5dfe7587a9731d066ddc557a38fd4c389f41539992072556664d92627b0d71"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.4/CLIProxyAPI_7.2.4_linux_amd64.tar.gz"
      sha256 "073c332ae899b060d6e079580ed2488c13f7a0ee553adcfed54c0010a595db38"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
