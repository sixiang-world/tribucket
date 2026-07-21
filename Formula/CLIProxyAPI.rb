class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.93"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.93/CLIProxyAPI_7.2.93_darwin_aarch64.tar.gz"
      sha256 "3ebffcf346c79925ff393225c2769a509a2297dcc1b8154c49235cb1d80a69ac"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.93/CLIProxyAPI_7.2.93_darwin_amd64.tar.gz"
      sha256 "1fa5b1324c43fada01234559f382ba0878681292f6d653056aef9ff99ccc7b86"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.93/CLIProxyAPI_7.2.93_linux_aarch64.tar.gz"
      sha256 "fc9d27799c97950614e98f191c3a6fea5c1b61bd390c44d2977090678b1c5794"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.93/CLIProxyAPI_7.2.93_linux_amd64.tar.gz"
      sha256 "3ca18073c87a7d21391dcc437558c37ee9b98ce1eb1cd2c013e064a236664322"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
