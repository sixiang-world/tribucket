class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.38"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.38/CLIProxyAPI_7.1.38_darwin_aarch64.tar.gz"
      sha256 "caac28211966e7a46663999fb0e972ad0c82c8eb6f0566fb2ab323851819321e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.38/CLIProxyAPI_7.1.38_darwin_amd64.tar.gz"
      sha256 "0c61c88caab77bbfdf628289518ca2206e9f10375f5460b368e72f3caaf69976"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.38/CLIProxyAPI_7.1.38_linux_aarch64.tar.gz"
      sha256 "a4ee6d648d766889b3cada45beb4e49edc564e7be63b09c97acb464b62a491a0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.38/CLIProxyAPI_7.1.38_linux_amd64.tar.gz"
      sha256 "db8ab40b89c788ade218a85131ce6fc275fd8557d38388ab87d6558a053d15e4"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
