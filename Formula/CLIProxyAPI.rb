class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.53"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.53/CLIProxyAPI_7.2.53_darwin_aarch64.tar.gz"
      sha256 "464599b1969d54747f1fc0260caff1abee9dd708101e5397bdca0bae7e68d556"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.53/CLIProxyAPI_7.2.53_darwin_amd64.tar.gz"
      sha256 "399c82bd51b016fddcb5d875bbd0ca2e57c6e99eb05caa85c0e13210980149ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.53/CLIProxyAPI_7.2.53_linux_aarch64.tar.gz"
      sha256 "9b163cfaf021a258caafb577cdc447fd336e30792be48e766d32746ca0b9ddd4"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.53/CLIProxyAPI_7.2.53_linux_amd64.tar.gz"
      sha256 "59231aa47196b671bcc1501dea9d2a386a36c75b110bbe8042e4ca35b18fe138"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
