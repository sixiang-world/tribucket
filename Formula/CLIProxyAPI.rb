class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.146"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.146/CLIProxyAPI_7.2.146_darwin_aarch64.tar.gz"
      sha256 "faf4c735b289cb88344f87fd6d745cf9a11d28a231d000173d8045910503b543"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.146/CLIProxyAPI_7.2.146_darwin_amd64.tar.gz"
      sha256 "1985f14f3a7caa40c4f7e6959c7c993db0b735317a1e690365d4c08d631849db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.146/CLIProxyAPI_7.2.146_linux_aarch64.tar.gz"
      sha256 "086ae6513aa522bbd1000f4e83e5b5223df6038bd69f1c6cad56619b84c06947"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.146/CLIProxyAPI_7.2.146_linux_amd64.tar.gz"
      sha256 "43e112686b4a5b7b818531144cd695eeaacdd54c46dced87be6fb3967c22e149"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
