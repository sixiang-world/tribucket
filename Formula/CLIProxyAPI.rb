class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.1.40"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.40/CLIProxyAPI_7.1.40_darwin_aarch64.tar.gz"
      sha256 "4bd0d86150c8a51e958ceb91b5b647eafddda5a0e4f62bb68ca0152a94fa86c2"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.40/CLIProxyAPI_7.1.40_darwin_amd64.tar.gz"
      sha256 "340c92280e2764fc06d21736510fb7b329176db46a4ed7cb3fcf49ee207801fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.40/CLIProxyAPI_7.1.40_linux_aarch64.tar.gz"
      sha256 "4fdca94182a8a71e0d44a7067d932442395ff522f8e068384bd429f25fe3a91f"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.1.40/CLIProxyAPI_7.1.40_linux_amd64.tar.gz"
      sha256 "3d8f7a749c3cc74d4128545347158f72fca34098ffda4ca339bac42ed4a36dfb"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
