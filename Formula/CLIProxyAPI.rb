class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.16/CLIProxyAPI_7.2.16_darwin_aarch64.tar.gz"
      sha256 "973bee457feef8aab39a873555bd76dab9307652dd9a59f65c7f4884dc52b060"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.16/CLIProxyAPI_7.2.16_darwin_amd64.tar.gz"
      sha256 "7ef7c5f703947a104d631a84338e5dabf1cbd72f49f865d9854028555194005b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.16/CLIProxyAPI_7.2.16_linux_aarch64.tar.gz"
      sha256 "84a301a649e9a30921538642bf67e42404f160ea4232454bbf7a4b2ca5389143"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.16/CLIProxyAPI_7.2.16_linux_amd64.tar.gz"
      sha256 "12ce66e4747454077d4c8f42ae16d7d5234e208b0531bd1475d49624be65a937"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
