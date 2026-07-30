class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.111"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.111/CLIProxyAPI_7.2.111_darwin_aarch64.tar.gz"
      sha256 "5892280dbe72684ce3f7f303bb607a187164a2c77b811036abeef6f68d4d13f1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.111/CLIProxyAPI_7.2.111_darwin_amd64.tar.gz"
      sha256 "6f703cb4facc71117eca8b716bcd4e65fffbea2bd09d3f864eb35cbb99491490"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.111/CLIProxyAPI_7.2.111_linux_aarch64.tar.gz"
      sha256 "d681f5eb8fc9ab6bbd83ffcd4305ccd74a3a1d6c9d45fafc1002e44e989a41db"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.111/CLIProxyAPI_7.2.111_linux_amd64.tar.gz"
      sha256 "c18c4fbddd1468566e4ae5d262791c3343d3b99a422f10671ea7139decb21e85"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
