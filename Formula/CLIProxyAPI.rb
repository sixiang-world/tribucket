class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.70"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.70/CLIProxyAPI_8.0.70_darwin_aarch64.tar.gz"
      sha256 "7ae4e3afd90b0eaf07da125ee0e1a7ffc80c1ba036b4bed9f9f8d6f63162504f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.70/CLIProxyAPI_8.0.70_darwin_amd64.tar.gz"
      sha256 "1433e34a5715ed5e79228541f58d953dc035a05cd1d309a06c3ed26c816b7d3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.70/CLIProxyAPI_8.0.70_linux_aarch64.tar.gz"
      sha256 "f56e3b4e85578a4aca2bdf6117bfc0751c32ed2c3b770c63bdc01ab3c2b3e725"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.70/CLIProxyAPI_8.0.70_linux_amd64.tar.gz"
      sha256 "8fccaa29caa81ca6fa5d5f129f1c1019768d07acd2cf4965408b2b8a72318a71"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
