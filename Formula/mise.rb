class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.12/mise-v2026.9.12-macos-arm64.tar.gz"
      sha256 "0f1c7f3e74d8c9ae82976e6990058f2bc68821acc6b4c37a68c206c836692419"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.12/mise-v2026.9.12-macos-x64.tar.gz"
      sha256 "22be38ec60632913143bf6a96b0aacfd895fdfe4ce4e8958e942f7bdb5a9185b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.12/mise-v2026.9.12-linux-arm64.tar.gz"
      sha256 "e4a0921da0a76ce4666832d5b57b6f0eb9f22d149ba92845ebae4c38638c6775"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.12/mise-v2026.9.12-linux-x64.tar.gz"
      sha256 "b4058dece685259910d3aba5782445996eea79dbdb3cf952a6eb81aadf0373ff"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
