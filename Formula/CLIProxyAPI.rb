class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.112"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.112/CLIProxyAPI_7.2.112_darwin_aarch64.tar.gz"
      sha256 "d8e41dd24f7f1ab68ed57d1637a928a13e7d217268093aa7d2177cf95010feff"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.112/CLIProxyAPI_7.2.112_darwin_amd64.tar.gz"
      sha256 "c9c1c36e7f134bb43e4155321d3c75037a4ba6c3173e8c6cfa70caff49903a55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.112/CLIProxyAPI_7.2.112_linux_aarch64.tar.gz"
      sha256 "254bb551ac71eb54720a6ee848ca8de559cdee5feb2dc1e44dbda59a03233220"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.112/CLIProxyAPI_7.2.112_linux_amd64.tar.gz"
      sha256 "a64de846ac2920b82cfbdfac988a3ae4f637eae9d2ff2fe00e4022cd451ca6e7"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
