class CcConnect < Formula
  desc "Claude Code connectivity utility"
  homepage "https://github.com/chenhg5/cc-connect"
  version "1.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.3.2/cc-connect-v1.3.2-darwin-arm64.tar.gz"
      sha256 "f03153feef8e46c606d0097a491e92448289fe3b91b70cba0b05f8740dfafe95"
    end
    on_intel do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.3.2/cc-connect-v1.3.2-darwin-amd64.tar.gz"
      sha256 "42177cf9f215c1f350e0c7a3306ce37f7b74301bbd23da0d9c229e17f661354c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.3.2/cc-connect-v1.3.2-linux-arm64.tar.gz"
      sha256 "90e491ee8ea8054b01c6152db72e286b0a6eb491db9babbdf570af2f8700c53e"
    end
    on_intel do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.3.2/cc-connect-v1.3.2-linux-amd64.tar.gz"
      sha256 "4ed25a62166c1a3a7c41eb3320d9b90172c56749aec5b88d36380829e4c8a182"
    end
  end

  def install
    bin.install Dir["cc-connect*"].first => "cc-connect"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-connect --version 2>&1", 1)
  end
end
