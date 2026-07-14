class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.6/mise-v2026.7.6-macos-arm64.tar.gz"
      sha256 "baeb42c21aec5dea45e0881b1619b8f65989187fa50481b1c70c4aa0af0429bb"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.6/mise-v2026.7.6-macos-x64.tar.gz"
      sha256 "e57eaa613672bc691bafc271f70de91350ac165c33955d35e2965067772e194c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.6/mise-v2026.7.6-linux-arm64.tar.gz"
      sha256 "1e5d2181bad9b897437e8227200fe661339bad7d66a3cd1828b22c48156ac73a"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.6/mise-v2026.7.6-linux-x64.tar.gz"
      sha256 "fbd2f36a5d726822e997b83b9ca29f66411de2acb2935dcabacd4df51a0dade3"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
