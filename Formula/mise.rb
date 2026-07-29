class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.16/mise-v2026.7.16-macos-arm64.tar.gz"
      sha256 "f3a7936ffed5741eeae4d3872c28f2feeefc791295bf21af957223b796e2bd12"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.16/mise-v2026.7.16-macos-x64.tar.gz"
      sha256 "6535bc960d572ecd187d7cfbcc90abf2d0c9e8e775ab03897d7dd7634396db5b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.16/mise-v2026.7.16-linux-arm64.tar.gz"
      sha256 "7311aca7ba2066ad6b1999662cb23ab04ed7311764e3112d6f872094862ef0b5"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.16/mise-v2026.7.16-linux-x64.tar.gz"
      sha256 "9ba22d5af56a1addd18161f45525b26e610a0b93c5860a176008429a10411dc5"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
