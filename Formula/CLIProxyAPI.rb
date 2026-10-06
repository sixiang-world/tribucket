class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.16/CLIProxyAPI_8.0.16_darwin_aarch64.tar.gz"
      sha256 "b2c48e27b62bc94c71387e43be287c742b0336f21e2fe203568233593983d495"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.16/CLIProxyAPI_8.0.16_darwin_amd64.tar.gz"
      sha256 "2c5a7e73f31d784f5732b6d24998286706b0dd60e7c6c1724988d9aeae2a4a0e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.16/CLIProxyAPI_8.0.16_linux_aarch64.tar.gz"
      sha256 "e84f37c92bf48a057e5c2ff3e2a30851a4e43c64efcf442473ea04a43b9ddebb"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.16/CLIProxyAPI_8.0.16_linux_amd64.tar.gz"
      sha256 "affb5a189184e41b4335549e498df6f4f1c7f15dd0d04a28286becc2dfa78579"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
