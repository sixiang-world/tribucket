class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.86"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.86/CLIProxyAPI_7.2.86_darwin_aarch64.tar.gz"
      sha256 "1c8cc23e183a4f6a5095b77aa268dbe555e7268580c7251031e8b5c16f1f7508"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.86/CLIProxyAPI_7.2.86_darwin_amd64.tar.gz"
      sha256 "3712d64259c0e2023305665b52083b6dcf6956f44b51dd2a0626f5b538d5cb50"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.86/CLIProxyAPI_7.2.86_linux_aarch64.tar.gz"
      sha256 "2bae5b54bf84ac18131234ebc8242ea796944ac412e54edccc1984b2db3bdeaf"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.86/CLIProxyAPI_7.2.86_linux_amd64.tar.gz"
      sha256 "f1827a374e07c30cb41754a16351f15323e94e030fa2fcec271dc6d717528044"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
