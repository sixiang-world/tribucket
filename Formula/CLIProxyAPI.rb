class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.36"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.36/CLIProxyAPI_7.1.36_darwin_aarch64.tar.gz"
      sha256 "83b91742ebbf1b34993ebda65e72cbdff3e8b2c3b0ebb479da826276baedb043"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.36/CLIProxyAPI_7.1.36_darwin_amd64.tar.gz"
      sha256 "f8de1d7676cf308a27e5d9805c1aa3c693626be630fc89a88579ab0003177e8f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.36/CLIProxyAPI_7.1.36_linux_aarch64.tar.gz"
      sha256 "37341a3f7f6ac7b86ce9c3f267ee56a717f857f45b15170fe6aaf1d3ef500544"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.36/CLIProxyAPI_7.1.36_linux_amd64.tar.gz"
      sha256 "684533c29310d25a708771acdd54f0c879dc50759fd7a78a6ffd5c556356df3e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
