class Zellij < Formula
  desc "Terminal multiplexer with batteries included"
  homepage "https://github.com/zellij-org/zellij"
  version "0.46.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.46.0/zellij-aarch64-apple-darwin.tar.gz"
      sha256 "716a1c7887be83cc813900012a156a4d8e0ee1468ac56c58a299c9d8898cdc90"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.46.0/zellij-x86_64-apple-darwin.tar.gz"
      sha256 "e3b6197af04b286f74f7a9f5f519e5a8cf048be65f0371a32b0d60abac97384a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.46.0/zellij-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c416b3d29ec9c71baf8754fe66663afe4f615395895e3f9b8b6e3bd0f7042427"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.46.0/zellij-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a8ee599eb357b6142443c91506a4ece3aa8811cb75dcf2b28d194bd66853c79d"
    end
  end

  def install
    bin.install Dir["zellij*"].first => "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version 2>&1", 1)
  end
end
