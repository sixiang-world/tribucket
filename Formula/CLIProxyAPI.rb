class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.149"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.149/CLIProxyAPI_7.2.149_darwin_aarch64.tar.gz"
      sha256 "90962c9194fe5470dc21f167b0cbf167a4f9ff2961a6bcc88f0b7eec32f1b49b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.149/CLIProxyAPI_7.2.149_darwin_amd64.tar.gz"
      sha256 "382f800a4d82fe39ee7158ca4f735a1a71d635fe0f1d9a55a4c5d13993ccc04e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.149/CLIProxyAPI_7.2.149_linux_aarch64.tar.gz"
      sha256 "2d290477295eba4e419bc231f1fb5d548edbdd4cd5654b34d26ed12f8dcd0ee7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.149/CLIProxyAPI_7.2.149_linux_amd64.tar.gz"
      sha256 "95d865dd17986da7d08cb39ffafe07d050669c5264d4d00115758ab4de752a72"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
