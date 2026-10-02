class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "8.0.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.12/CLIProxyAPI_8.0.12_darwin_aarch64.tar.gz"
      sha256 "41c32c3b1448f65a204c397b62f94bc12894998b480a8b5852af49dabb8397cd"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.12/CLIProxyAPI_8.0.12_darwin_amd64.tar.gz"
      sha256 "33f809f78a7833493013ca8731325fa4d4fe58fb68d41c99e7b2e1eaaf7aa6bf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.12/CLIProxyAPI_8.0.12_linux_aarch64.tar.gz"
      sha256 "49cd6ecf5742a503bb5108a2a16d63e268037c48eb8e2b21c7d32b09171a61c2"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v8.0.12/CLIProxyAPI_8.0.12_linux_amd64.tar.gz"
      sha256 "433cea2c608cdb19bb22d22ea4041ee691dbeeacf38695f385a702b6b8682f7d"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
