class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.82"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.82/CLIProxyAPI_7.2.82_darwin_aarch64.tar.gz"
      sha256 "00839c09dbb8baebc48986cc488c6a47708bf47c5a8b9a2b4f9de6d22e158b00"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.82/CLIProxyAPI_7.2.82_darwin_amd64.tar.gz"
      sha256 "a20f546b09f3b8db06c65305faeff1eda169c0f80b8aca05e11b54ca571eed1e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.82/CLIProxyAPI_7.2.82_linux_aarch64.tar.gz"
      sha256 "bbcadd129d4195b94851e5cd8602410a0725045e654a91abc1cd967b4a17935b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.82/CLIProxyAPI_7.2.82_linux_amd64.tar.gz"
      sha256 "10c588f9957257b8d322318167c14d8a8fd7aa5315c528c1ea0ddb21843b7019"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
