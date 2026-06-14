class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.2/CLIProxyAPI_7.2.2_darwin_aarch64.tar.gz"
      sha256 "f5039db6394fe1da2f791d5c8c55123ca590c09b21790a68adeb13d4a285f838"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.2/CLIProxyAPI_7.2.2_darwin_amd64.tar.gz"
      sha256 "1dfb67b5b09678c40f150b6e67663aee4f72b72c7071982e072ba1563edd30f7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.2/CLIProxyAPI_7.2.2_linux_aarch64.tar.gz"
      sha256 "075d83105d1df06df20dfae5fcafce07b704b03c627651a475f4b9398c3a4107"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.2/CLIProxyAPI_7.2.2_linux_amd64.tar.gz"
      sha256 "6457ce3694ca50fbaf18fd7edc8cf4ac752567da76c41fdb1276a655efc08c63"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
