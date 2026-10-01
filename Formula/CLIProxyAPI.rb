class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.8/CLIProxyAPI_8.0.8_darwin_aarch64.tar.gz"
      sha256 "df48fe6a6e5c60d1966ed374e6b0567cb8c87180df9dd14dfb25f42365b4bb25"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.8/CLIProxyAPI_8.0.8_darwin_amd64.tar.gz"
      sha256 "6549a010e18f34a5d70464f1ef7cf5506ef43b0e260b266cc0869fe519fb9d34"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.8/CLIProxyAPI_8.0.8_linux_aarch64.tar.gz"
      sha256 "781224691d50a4107b0132326fa58e246d34ef98e65649db02fe1a3eb1e2cc60"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.8/CLIProxyAPI_8.0.8_linux_amd64.tar.gz"
      sha256 "0b97f31ad5fd357928c7278545c01ade4dfb96a022c31135239082807df68407"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
