class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.25"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.25/CLIProxyAPI_8.0.25_darwin_aarch64.tar.gz"
      sha256 "d7e074ea78e91cfab2d871d24b8861d1eb27846c1bbc39030ccd368b2a70828c"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.25/CLIProxyAPI_8.0.25_darwin_amd64.tar.gz"
      sha256 "5416a0809510add8fbc03d003fb2cf6979e575bcf48a7c3bb562933c3cc6c3d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.25/CLIProxyAPI_8.0.25_linux_aarch64.tar.gz"
      sha256 "6a348af232e9bd137cb0ec10af5e26c10253c87eff4a1dc7784058ce14a13f5f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.25/CLIProxyAPI_8.0.25_linux_amd64.tar.gz"
      sha256 "257f3d3e0e1c388aea348a3d5bd7074b7ec1dd1da5c2f33d4144be6c9a43cc8e"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
