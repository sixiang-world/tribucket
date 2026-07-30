class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.109"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.109/CLIProxyAPI_7.2.109_darwin_aarch64.tar.gz"
      sha256 "315a4d74ebafcb12ccb8a1fa65c66e9600c7e9a5554f04dcf859682ae3ce2d36"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.109/CLIProxyAPI_7.2.109_darwin_amd64.tar.gz"
      sha256 "f7876a6d48d23cd3327dacbe7837d8d1319580b2d847186a0d56f73535d4924f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.109/CLIProxyAPI_7.2.109_linux_aarch64.tar.gz"
      sha256 "fb4ae379df125e50dbaf7deda591c94b3e0c4b96ace584e8a10f1a9452551126"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.109/CLIProxyAPI_7.2.109_linux_amd64.tar.gz"
      sha256 "ab4517f88c51ae384594dd6ec07e02e78af74e78fc1a6bdbf5702f939ad1db41"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
