class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.56"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.56/CLIProxyAPI_7.1.56_darwin_aarch64.tar.gz"
      sha256 "f35b3a308ff468eb7e01859d3eb1a234bc7a852e00a47329aca2b652f20469ca"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.56/CLIProxyAPI_7.1.56_darwin_amd64.tar.gz"
      sha256 "ba384e67e6fad3fec354eb6da5e6c524f501720c825ec7e2cd7062db0a5e18c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.56/CLIProxyAPI_7.1.56_linux_aarch64.tar.gz"
      sha256 "7c8ccc6c3425f4c9b8a1142460444b452c35bac2f6d366f785068c4649cd2c7b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.56/CLIProxyAPI_7.1.56_linux_amd64.tar.gz"
      sha256 "cb19b78374f8737f3d442af05d03e90b2b0e9189a70dc896c5f72f18f88511df"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
