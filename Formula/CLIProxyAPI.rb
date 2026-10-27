class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.44"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.44/CLIProxyAPI_8.0.44_darwin_aarch64.tar.gz"
      sha256 "50b75e0bcec8576b93561f2ab2941ff08af26fc9273cf686e9c2b337716bbc46"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.44/CLIProxyAPI_8.0.44_darwin_amd64.tar.gz"
      sha256 "bf605a5a0c432bb85ca219a3ba5963b2cc65d3dcec4aad3ab61e46f1895e3a65"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.44/CLIProxyAPI_8.0.44_linux_aarch64.tar.gz"
      sha256 "2793502b5cf910528f797d2392c49ec9e87f5e7cc16db4c7bec7cb6a23370528"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.44/CLIProxyAPI_8.0.44_linux_amd64.tar.gz"
      sha256 "3957c34fe4a95a37f5997ab63d78dca431fa1521997d7c2ab3bdfe169ad89307"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
