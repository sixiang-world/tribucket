class Cliproxyapi < Formula
  desc "CLI proxy API tool with wide platform support"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  version "7.2.159"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.159/CLIProxyAPI_7.2.159_darwin_aarch64.tar.gz"
      sha256 "ff6df9e2181bdc13deb011e935eecfeea10b03fde1cb896aa5db1f2a172d625d"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.159/CLIProxyAPI_7.2.159_darwin_amd64.tar.gz"
      sha256 "7dd08aba651f6b4fa3a1ec2e3af7e6b47df0aa46b1f9c400b759588a8911fcee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.159/CLIProxyAPI_7.2.159_linux_aarch64.tar.gz"
      sha256 "a80bd08bfc32b95601db9b84b57683a88057897bfd0229b8043b3dd6d356f287"
    end
    on_intel do
      url "https://github.com/router-for-me/CLIProxyAPI/releases/download/v7.2.159/CLIProxyAPI_7.2.159_linux_amd64.tar.gz"
      sha256 "942d567a525d0f8dd0e78c2843cfefae7f553c0a385c859c20951b12d8a48218"
    end
  end

  def install
    bin.install Dir["CLIProxyAPI*"].first => "CLIProxyAPI"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/CLIProxyAPI --version 2>&1", 1)
  end
end
