class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.43"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.43/CLIProxyAPI_7.1.43_darwin_aarch64.tar.gz"
      sha256 "758f6e40de683bcc707c3263c512d99fc529ed1942f93700ef00b2bfdc722d95"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.43/CLIProxyAPI_7.1.43_darwin_amd64.tar.gz"
      sha256 "8d549669a234483429838eb1598ec3fad72197fa8ad70e4b4768b337c1590810"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.43/CLIProxyAPI_7.1.43_linux_aarch64.tar.gz"
      sha256 "f7e4d30e0ee23de7a82ee6d39495bebc5be6cd672b8ffed10d4419f85676142f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.43/CLIProxyAPI_7.1.43_linux_amd64.tar.gz"
      sha256 "97418b185739538235d3c829897e3705a1f9c729c22a3f1331b13ecb2a3cd6bf"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
