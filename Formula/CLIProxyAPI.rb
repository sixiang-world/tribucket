class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.53"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.53/CLIProxyAPI_8.0.53_darwin_aarch64.tar.gz"
      sha256 "24a9116a9be459e9d1df5a9792eca17f04c0bb8505584d40c5b255565d07186f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.53/CLIProxyAPI_8.0.53_darwin_amd64.tar.gz"
      sha256 "7105389234f1b2cb7c045a52b3c2d3eced83fed8de1228567759817a0c8c6b2d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.53/CLIProxyAPI_8.0.53_linux_aarch64.tar.gz"
      sha256 "b68ecfef89a0ce576332742ae5435353fb64dc28d93f9d1ca93d50385a942989"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.53/CLIProxyAPI_8.0.53_linux_amd64.tar.gz"
      sha256 "96bdc1ec195adc23baae6eb0413a9dce2fdccf03c0d3fd290e91aa8812e2a70d"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
