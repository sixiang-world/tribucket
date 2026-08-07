class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.122"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.122/CLIProxyAPI_7.2.122_darwin_aarch64.tar.gz"
      sha256 "2b7c3a4055f00120958e483e536e1ef6b406b90c0a9f503e3ade764d32ba4bcf"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.122/CLIProxyAPI_7.2.122_darwin_amd64.tar.gz"
      sha256 "75b9fccffc268de71625e4bc90166bc898c0b3828db3df6b0228d9bcac155f67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.122/CLIProxyAPI_7.2.122_linux_aarch64.tar.gz"
      sha256 "553cb5e957aeda67ebeb0813e4f0a5bedb40c20fa017bd50f9abcea333bbf42b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.122/CLIProxyAPI_7.2.122_linux_amd64.tar.gz"
      sha256 "e11e74d988d225bf0556a0f10dcc694e06bbeb79d68b0f3640d5d36e1c73a575"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
