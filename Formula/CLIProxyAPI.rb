class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.21"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.21/CLIProxyAPI_7.2.21_darwin_aarch64.tar.gz"
      sha256 "be47f432656a7e0d3f7f678814390ab09e18ebf6614ef4e7cdade9b90713caed"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.21/CLIProxyAPI_7.2.21_darwin_amd64.tar.gz"
      sha256 "d6982748f38448cf3f341ee404770d336991c2e7a32ad36d2f08064bf9dea852"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.21/CLIProxyAPI_7.2.21_linux_aarch64.tar.gz"
      sha256 "462f604bf702724aabf34ed257de0a7b99b7ab570a4266fc2d9193388a3c0ad5"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.21/CLIProxyAPI_7.2.21_linux_amd64.tar.gz"
      sha256 "173cbfcc78f7340cefdb58e1fe6770417e653c55db704ef280a602c86fbfda82"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
