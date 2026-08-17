class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.135"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.135/CLIProxyAPI_7.2.135_darwin_aarch64.tar.gz"
      sha256 "c5f6e785cf7568c177d5c31aa75c389c4bb1b1dee9e0133887b9bce3200475dd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.135/CLIProxyAPI_7.2.135_darwin_amd64.tar.gz"
      sha256 "d171e00b47c00c07e34c53fc93f9b71b8db23ef23496c3b6994038940f319c4c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.135/CLIProxyAPI_7.2.135_linux_aarch64.tar.gz"
      sha256 "a88545c985835bcb038127c050acf92e672b354dd11f891ddb658d56d254d6dd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.135/CLIProxyAPI_7.2.135_linux_amd64.tar.gz"
      sha256 "f5e5ccf0f3fead3a2ee088cb37a69e996f05b33b47f116b4351dbfd1d4224241"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
