class Octopus < Formula
  desc "Multi-platform CLI tool"
  homepage "https://github.com/bestruirui/octopus"
  version "0.13.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.5/octopus-darwin-arm64.zip"
      sha256 "43d89ec85aadd2f9703192be72e2238ede8277976fb44320098577af8a4dec23"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.5/octopus-darwin-amd64.zip"
      sha256 "798ad819b053f78bb5e2aad1e9b8d469ca26a6cce9ef0fa1eb6d8f990fac88a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.5/octopus-linux-arm64.zip"
      sha256 "50081ee770b2f80632d1a860a64638c9f0f51833f03120dfad89ab1d2bbaf018"
    end
    on_intel do
      url "https://github.com/bestruirui/octopus/releases/download/v0.13.5/octopus-linux-amd64.zip"
      sha256 "f168729206a6d2288b43995fcf573e491715ccaa35ee6097fc3b960ec9ef2e5f"
    end
  end

  def install
    bin.install Dir["octopus*"].first => "octopus"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octopus --version 2>&1", 1)
  end
end
