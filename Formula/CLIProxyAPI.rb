class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.99"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.99/CLIProxyAPI_7.2.99_darwin_aarch64.tar.gz"
      sha256 "626a0ffe0a8f59e69948636d0122960466a717ce7e7b9530bc3ab3cbe38f45d7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.99/CLIProxyAPI_7.2.99_darwin_amd64.tar.gz"
      sha256 "0185e9d5f2408d55b4437f352c90d89ef765ef7c58d9e7c9ef6f9f33188fa638"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.99/CLIProxyAPI_7.2.99_linux_aarch64.tar.gz"
      sha256 "8df02ffb5bc3d8fbfe2690fd5852bf40c71faea59f5dc06e55b2a04bfa39af26"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.99/CLIProxyAPI_7.2.99_linux_amd64.tar.gz"
      sha256 "9bfed2e639aafefd11214f253e9f199d3ac6d5da14a4eb7a596742f47e6b4951"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
