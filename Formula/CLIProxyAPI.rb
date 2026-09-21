class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.11/CLIProxyAPI_7.3.11_darwin_aarch64.tar.gz"
      sha256 "5671e4c7cf96919f35bd2bd76c68c6d57448219de655f5ca2db186b9534b7754"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.11/CLIProxyAPI_7.3.11_darwin_amd64.tar.gz"
      sha256 "dc4a75ef7256667959e2eb7e5c37bec5178f08f36657becf73fa65ef8a1cc118"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.11/CLIProxyAPI_7.3.11_linux_aarch64.tar.gz"
      sha256 "8c5a2bd09aca61b2d7753bee25609e0483c9047dee383b08fa5c3527aa9a75ae"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.11/CLIProxyAPI_7.3.11_linux_amd64.tar.gz"
      sha256 "4fc3e20aa6ab896316ac70633c8ed08b10d4219d1c3075d5b145b422c6bfab64"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
