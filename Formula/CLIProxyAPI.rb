class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.98"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.98/CLIProxyAPI_7.2.98_darwin_aarch64.tar.gz"
      sha256 "f64f14665227f08bec395bb3cc37fe75b562f58ebf8080d7ed74b6d182f5ce60"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.98/CLIProxyAPI_7.2.98_darwin_amd64.tar.gz"
      sha256 "0b260e66d441371f2d025cbef02aa678712b8f1d4251c480da7cca56afacf052"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.98/CLIProxyAPI_7.2.98_linux_aarch64.tar.gz"
      sha256 "eb7ba1d542efad3f893e1ac6235c1d0a08264a594bf6a149389949191152b965"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.98/CLIProxyAPI_7.2.98_linux_amd64.tar.gz"
      sha256 "b73e240f8e4bb5a53414780ca3d1de3af96f1669a824a8816679d1ab2b5d0de0"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
