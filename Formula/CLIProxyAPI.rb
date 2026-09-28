class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.3/CLIProxyAPI_8.0.3_darwin_aarch64.tar.gz"
      sha256 "01c424674ad4ceacfe86a1faa32e194ba8e278e8ec22c8b5d606d67c3c56a858"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.3/CLIProxyAPI_8.0.3_darwin_amd64.tar.gz"
      sha256 "236e2ba36a6f78b940022d250deb6498536db4395d161407aa1179c85fc529ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.3/CLIProxyAPI_8.0.3_linux_aarch64.tar.gz"
      sha256 "2a42b30ef6e981fea9296a64040bd99dade90ceb05c920387cad85a426d9b634"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.3/CLIProxyAPI_8.0.3_linux_amd64.tar.gz"
      sha256 "0556446ae0d5941c019252631987cc3b738c6608b855328ece979ab2188ed6dd"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
