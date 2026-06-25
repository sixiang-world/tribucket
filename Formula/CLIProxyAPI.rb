class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.40"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.40/CLIProxyAPI_7.2.40_darwin_aarch64.tar.gz"
      sha256 "e36ebd5a1e05cd03fbc290614b0bf7e1d55b35a184b5d44a2f209a8f01324d45"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.40/CLIProxyAPI_7.2.40_darwin_amd64.tar.gz"
      sha256 "109f082a2081e40abb9277c1d2f2d7b5278fa5e249bd43da3dec90ee8cb6815b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.40/CLIProxyAPI_7.2.40_linux_aarch64.tar.gz"
      sha256 "f87190e494a25fa0a7bfadd325875ccbb5eef6089653e01dbe1516408922ffcc"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.40/CLIProxyAPI_7.2.40_linux_amd64.tar.gz"
      sha256 "854115b1b4986a8a9d6d53b0b468a03c1dc1253e9d966de0a52f531647c529b4"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
