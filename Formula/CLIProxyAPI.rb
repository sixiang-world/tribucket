class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.48"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.48/CLIProxyAPI_8.0.48_darwin_aarch64.tar.gz"
      sha256 "543bdbc6f8384fecd033bf7398236e46279962a80dbc909cf8d8e6ee94ccfc04"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.48/CLIProxyAPI_8.0.48_darwin_amd64.tar.gz"
      sha256 "97f662d40bc3da1bd6bb0f9188ba803d11e0cb29dfc037376bb655bf3f437781"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.48/CLIProxyAPI_8.0.48_linux_aarch64.tar.gz"
      sha256 "9ed7c06aa96d9cc6736ddfc897de07b8b6085731785087f6701f07ec9ec198dd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.48/CLIProxyAPI_8.0.48_linux_amd64.tar.gz"
      sha256 "095c46e7165842cf563f9665be86cf24a29ba94e57ab9bd67588fe5cc4c7125c"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
