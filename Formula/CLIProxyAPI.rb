class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.66"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.66/CLIProxyAPI_7.1.66_darwin_aarch64.tar.gz"
      sha256 "4fdabfd03d56013dde879ed34d16a91871e29f8ad7a8890578a0c91790f6b15d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.66/CLIProxyAPI_7.1.66_darwin_amd64.tar.gz"
      sha256 "87bf986c6d935b92dc095aab5d62189b68d1478b15dfa8d03b304a641ebd7c5e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.66/CLIProxyAPI_7.1.66_linux_aarch64.tar.gz"
      sha256 "804cdb3b6bb579e7255fa8775c5c2f240650b1883acb7cb5ebf4069987125a42"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.66/CLIProxyAPI_7.1.66_linux_amd64.tar.gz"
      sha256 "432a9bda142cc1df562c0a6dfa767072b72adb33a046616b3a0ca98dc695280d"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
