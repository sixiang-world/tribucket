class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.9/CLIProxyAPI_8.0.9_darwin_aarch64.tar.gz"
      sha256 "f696ee2a352a6e9e0488c2c945ae0df92430f5c5f6555a3b14e9db174dcb11c5"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.9/CLIProxyAPI_8.0.9_darwin_amd64.tar.gz"
      sha256 "59e5951f2777b78921a5d073d69a97a9bb64c9b849d3355ef6703a0247527459"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.9/CLIProxyAPI_8.0.9_linux_aarch64.tar.gz"
      sha256 "1dcc6893a470d111b075c0f2b85d893b03696e5dad96afc664e5349ced4fae1f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.9/CLIProxyAPI_8.0.9_linux_amd64.tar.gz"
      sha256 "3e2fc370377c895d3e2b4665ccf6a98bad165db95ef6c63d6c943fb4cafe63f2"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
