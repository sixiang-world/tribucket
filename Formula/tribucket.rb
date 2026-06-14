class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.1/tribucket-darwin-arm64"
      sha256 "54e1e468cc65f5f187526fd7ed9e5b9fa0913bc269d8d0b6cb55752a8e1301eb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.1/tribucket-linux-arm64"
      sha256 "4ee929a160e296d99d0ba65ca5673a37c35f45f0dd58b95909df7ba01d45e46a"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.2.1/tribucket-linux-amd64"
      sha256 "c79fa3e1383a842a0ae6529f210021a9e32dc6a99b8c30304958446491aafeca"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
