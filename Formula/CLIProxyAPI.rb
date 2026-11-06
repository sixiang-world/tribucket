class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.57"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.57/CLIProxyAPI_8.0.57_darwin_aarch64.tar.gz"
      sha256 "dd620c0d24e000ffe908d0d8eeb4a6c7315a31d3776fa09f198856b09fd7821f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.57/CLIProxyAPI_8.0.57_darwin_amd64.tar.gz"
      sha256 "428ad123451238972d208ba76d360df461517647e78bcb2ef8ab7cce5b3eebe1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.57/CLIProxyAPI_8.0.57_linux_aarch64.tar.gz"
      sha256 "62ec089e714af886b152e5eaf9010aaa5feb17b2a964d17b338b03316ed22144"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.57/CLIProxyAPI_8.0.57_linux_amd64.tar.gz"
      sha256 "1e7b31c4bdbfeb91947fbb686933c36234ffa84c1beb781c7c020c035763545e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
