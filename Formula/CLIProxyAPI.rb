class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.27"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.27/CLIProxyAPI_8.0.27_darwin_aarch64.tar.gz"
      sha256 "d9bf58db6e07d0f587a248abc4a1099178fbec1d659d874c961d8caf3495a09e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.27/CLIProxyAPI_8.0.27_darwin_amd64.tar.gz"
      sha256 "8ca6317fe7560a0452d2835f296a6360de8bc88099670c68635fd1cf4132c8d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.27/CLIProxyAPI_8.0.27_linux_aarch64.tar.gz"
      sha256 "5ef174b13320d2061dc33cb0ee3db31dbbf2cd947ab2e02edd5b16ac035e8b2a"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.27/CLIProxyAPI_8.0.27_linux_amd64.tar.gz"
      sha256 "82d38c89a62a2787f91e244595e0e76e52d6caaf2aa3d1a19b617e554c72b449"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
