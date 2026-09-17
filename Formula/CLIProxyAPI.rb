class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.3.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.6/CLIProxyAPI_7.3.6_darwin_aarch64.tar.gz"
      sha256 "f512aafc4e38d250bd128f4ec787347aafea85d7cdaa055ba028111a83a878f3"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.6/CLIProxyAPI_7.3.6_darwin_amd64.tar.gz"
      sha256 "f1dd289cba2ddbac6b4aa323b80b7c42599bdda13b66091c508765963e3de4ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.6/CLIProxyAPI_7.3.6_linux_aarch64.tar.gz"
      sha256 "d4d5c92a8464c98f0787bcbf3b3e3ee7002b6044e125aeaf1c5d36632025eef0"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.3.6/CLIProxyAPI_7.3.6_linux_amd64.tar.gz"
      sha256 "f0581917ba4d14ad935eb8f00ec242645d2cf630e31e435a7bce5957fdbd466a"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
