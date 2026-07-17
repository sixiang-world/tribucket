class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.85"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.85/CLIProxyAPI_7.2.85_darwin_aarch64.tar.gz"
      sha256 "5a547864bd140b5e51a6a79e01871bbf78a8f3b464643b2943054e27a8dbffce"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.85/CLIProxyAPI_7.2.85_darwin_amd64.tar.gz"
      sha256 "28a6d2b80f4b900a7af4a9493e92390050914948205038c5f320f4f7ee7225f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.85/CLIProxyAPI_7.2.85_linux_aarch64.tar.gz"
      sha256 "382d58dbaa9ab0c873b88104568205eafdc89ecbd7347cb53e53406676947cb1"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.85/CLIProxyAPI_7.2.85_linux_amd64.tar.gz"
      sha256 "d18fec1f4046ab158e8b35f7a2860ac64b2c04f5a1a15e633f633232c4ebb2d7"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
