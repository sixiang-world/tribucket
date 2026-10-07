class QqmailCli < Formula
  desc "Unofficial safety-first QQ Mail CLI for scripts and AI agents"
  homepage "https://github.com/sixiang-world/qqmail-cli"
  version "0.5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_darwin_arm64.tar.gz"
      sha256 ""
    end
    on_intel do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_darwin_amd64.tar.gz"
      sha256 ""
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_linux_arm64.tar.gz"
      sha256 ""
    end
    on_intel do
      url "https://github.com/sixiang-world/qqmail-cli/releases/download/v0.5.0/qqmail-cli_0.5.0_linux_amd64.tar.gz"
      sha256 ""
    end
  end

  def install
    bin.install Dir["qqmail-cli*"].first => "qqmail-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qqmail-cli --version 2>&1", 1)
  end
end
