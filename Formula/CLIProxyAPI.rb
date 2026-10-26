class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.43"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.43/CLIProxyAPI_8.0.43_darwin_aarch64.tar.gz"
      sha256 "3c2df9d8036507618754fdc01aa18f5dda2e1b16f5a3e48bae9a88d08a668e89"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.43/CLIProxyAPI_8.0.43_darwin_amd64.tar.gz"
      sha256 "45a890650badaabb24d403535d792a89d21a8c75c2f2d516ace219e9c14560e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.43/CLIProxyAPI_8.0.43_linux_aarch64.tar.gz"
      sha256 "df5e6c09bb942f281f036b443cb260d844f96002cf30f57869a5d3770c7c553e"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.43/CLIProxyAPI_8.0.43_linux_amd64.tar.gz"
      sha256 "7825540634898e11fe9baf255b683856da5d9e75b95c66835891ebb40a79b526"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
