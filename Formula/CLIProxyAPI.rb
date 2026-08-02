class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.114"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.114/CLIProxyAPI_7.2.114_darwin_aarch64.tar.gz"
      sha256 "f84cc31832d07709bfe565c887bd1c9679a949d0952dcdb6d8e6f98c7841f54b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.114/CLIProxyAPI_7.2.114_darwin_amd64.tar.gz"
      sha256 "1bd6eae86a8b6d8ef3d44e1f99d7b22ab5f1cda8691657a5daf4dfe9398c66f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.114/CLIProxyAPI_7.2.114_linux_aarch64.tar.gz"
      sha256 "6fd63c1a3c8f623833d10e7cab6c4032f67fd3aecad1ecc6cac89c17a221ed6b"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.114/CLIProxyAPI_7.2.114_linux_amd64.tar.gz"
      sha256 "85084fd67f37d5d78a198564c4ac2758d1d57abab2f212572a8dbe01c06f4a89"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
