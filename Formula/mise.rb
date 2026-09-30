class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.18/mise-v2026.9.18-macos-arm64.tar.gz"
      sha256 "b3539de1a9823505269481b71d09a9cf86e141c63ebfc6101b3cf561766a83e8"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.18/mise-v2026.9.18-macos-x64.tar.gz"
      sha256 "e1fd0d0a7c93428cc4eaf61a0bdb26f0a50d4401283458c1182d3dcc6fb9b234"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.18/mise-v2026.9.18-linux-arm64.tar.gz"
      sha256 "4a06b8cc295390e606b9103a29a3b49a1efba75092b05c8aca56b8367f636b37"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.18/mise-v2026.9.18-linux-x64.tar.gz"
      sha256 "4312f8fd72a8d6a869cd2aca7444929e2a0ef6f45d2c6f2866a1eacc5bdc2e84"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
