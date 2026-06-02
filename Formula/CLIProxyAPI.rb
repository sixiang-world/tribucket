class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.39"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.39/CLIProxyAPI_7.1.39_darwin_aarch64.tar.gz"
      sha256 "3dd48a6d19d11e65a5d025b4c98e6ba397d79ea6d4c363e4fb79790c42fef2d9"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.39/CLIProxyAPI_7.1.39_darwin_amd64.tar.gz"
      sha256 "c1258acf98f2e6a159be804dcdc65ef04c7efd7edec3f8c15b195e363ccde843"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.39/CLIProxyAPI_7.1.39_linux_aarch64.tar.gz"
      sha256 "d73ef8baf4e6e1372a253c110cedca67fc9e5cb775d602446a46280d6f98589f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.39/CLIProxyAPI_7.1.39_linux_amd64.tar.gz"
      sha256 "0d203828b3e1de85f7a92a8af683aea842160ed57bcbcd2bda5f14d16c37fbaa"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
