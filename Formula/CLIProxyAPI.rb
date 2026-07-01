class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.48"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.48/CLIProxyAPI_7.2.48_darwin_aarch64.tar.gz"
      sha256 "9d2d0bf7f1c49b51890e4162d8eba6aec4363f047958a662028dc2bcccbc0d4d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.48/CLIProxyAPI_7.2.48_darwin_amd64.tar.gz"
      sha256 "758e894cce9d5f92e8361657734b40fc28fe69b59879278c8345573c52e2cd6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.48/CLIProxyAPI_7.2.48_linux_aarch64.tar.gz"
      sha256 "b241a46972e3dcd8ea83742465f554209af3b621dd01bf82ade98353c5abc0de"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.48/CLIProxyAPI_7.2.48_linux_amd64.tar.gz"
      sha256 "c57b70f5bfd43967a33195f6bb5a8edb837d3e6ff4493b41a263f65f9c8995b5"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
