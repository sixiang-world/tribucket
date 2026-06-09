class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.58"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.58/CLIProxyAPI_7.1.58_darwin_aarch64.tar.gz"
      sha256 "a49c62bb0e172f99d1fef54c1db62c0ec9763ac35b08e6bcfbe01d3d021345e7"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.58/CLIProxyAPI_7.1.58_darwin_amd64.tar.gz"
      sha256 "bfdcab82af4cedd8d31ea09aa603921d8b9e2e3eaa9a97a778ee853bacb0e88f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.58/CLIProxyAPI_7.1.58_linux_aarch64.tar.gz"
      sha256 "f1caf7be543b51adf5b2e625be7a08f9543ceb6e90187a0da8f9dfc2cff53741"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.58/CLIProxyAPI_7.1.58_linux_amd64.tar.gz"
      sha256 "05f32c62c445985a19aae7a2b97c535c445e6d58b7ab8deab2593915a2e98610"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
