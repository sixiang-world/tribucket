class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.46"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.46/CLIProxyAPI_7.1.46_darwin_aarch64.tar.gz"
      sha256 "d0f4292d4090a651e7e9ba4698adb7370720f55013d2a71a3cef71efe7361290"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.46/CLIProxyAPI_7.1.46_darwin_amd64.tar.gz"
      sha256 "88c540cc84c73be53ee447e25460a3272947e830b39654121ee28a84cf8b1c16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.46/CLIProxyAPI_7.1.46_linux_aarch64.tar.gz"
      sha256 "1d02bafa91d3ba6086a723c0d3a4a84843e7bc34f71cbd94c65d4641f2c195dd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.46/CLIProxyAPI_7.1.46_linux_amd64.tar.gz"
      sha256 "77d13490ca93fd03ce7f6a07fc7bcde12133fd8fd568e42a5ef1508ddf12b37b"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
