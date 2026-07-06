class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.51"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.51/CLIProxyAPI_7.2.51_darwin_aarch64.tar.gz"
      sha256 "b8863ae28ae9f8dcbc189f703e452f2f4e48e22bc56b2e9771c252fbf80875e4"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.51/CLIProxyAPI_7.2.51_darwin_amd64.tar.gz"
      sha256 "aa096054684989ac546d78e6c842fbd4146d29d02701024a30aebb0374bb2720"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.51/CLIProxyAPI_7.2.51_linux_aarch64.tar.gz"
      sha256 "b044291b77f980f3bebf1e49f6e65090349639173d4aab4cdc88ff1c7abde443"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.51/CLIProxyAPI_7.2.51_linux_amd64.tar.gz"
      sha256 "88244334c5029836fb0caefd2bd335ae2b1454589aa9cc49ad9de04133ab4fba"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
