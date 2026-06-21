class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.26"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.26/CLIProxyAPI_7.2.26_darwin_aarch64.tar.gz"
      sha256 "e0b4eedf3f5f3d6a93587612b4fe5e3c34caf6e8b3c5bf04ec17a8cf30cea15c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.26/CLIProxyAPI_7.2.26_darwin_amd64.tar.gz"
      sha256 "74e7c823c131175f55487887b05d0de71e07c75573597487a5a1fdd077b8c63a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.26/CLIProxyAPI_7.2.26_linux_aarch64.tar.gz"
      sha256 "da845653f36c712c7b75603640f3450d34b8bd3e6398fbb05cf3320dce212f88"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.26/CLIProxyAPI_7.2.26_linux_amd64.tar.gz"
      sha256 "633302578d5d093c633630c9de0a39a0fc2bcf7808f12786844b383f171c90ab"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
