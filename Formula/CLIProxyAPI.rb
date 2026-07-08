class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.54"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.54/CLIProxyAPI_7.2.54_darwin_aarch64.tar.gz"
      sha256 "eda349dda0f3c575944a749f44b1b63119a654d03705df2288bdb072e939dccc"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.54/CLIProxyAPI_7.2.54_darwin_amd64.tar.gz"
      sha256 "c5cf41be2ffbe60b100b553f992bc614665abbad7a7719babf3ebf9e329c651b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.54/CLIProxyAPI_7.2.54_linux_aarch64.tar.gz"
      sha256 "ba3fec06b0e98b6980575af1bc430126fd4986f677131ebd7744c1f2f0e97c68"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.54/CLIProxyAPI_7.2.54_linux_amd64.tar.gz"
      sha256 "3a42ec8646847910c77e58149cc5d62cacd83372f02619464d904428746c8961"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
