class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.33"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.33/CLIProxyAPI_8.0.33_darwin_aarch64.tar.gz"
      sha256 "2e3da8d3d97625e38186faad178b724f3f4760e17a2ccee12007b34f5f94d692"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.33/CLIProxyAPI_8.0.33_darwin_amd64.tar.gz"
      sha256 "f47c91beea63b9e48bf48b852e5f91c47ca1d244f59814edf112f726dc894296"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.33/CLIProxyAPI_8.0.33_linux_aarch64.tar.gz"
      sha256 "ad2f01e75770e10cc2dafc3191ac98daec14dbc6668135d5bec455ca36f34d2f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.33/CLIProxyAPI_8.0.33_linux_amd64.tar.gz"
      sha256 "16c40b08ace32c5b8956d61385d9d41c312b744412fd10cb547139809cf9e49b"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
