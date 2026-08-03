class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.1/mise-v2026.8.1-macos-arm64.tar.gz"
      sha256 "a46b90cc09bdd0c846380273f3e6d60f54911ce098b20622b9b5802b59a174be"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.1/mise-v2026.8.1-macos-x64.tar.gz"
      sha256 "e606c872a0f86b845197aa079aded648d78a6b7cf1dda38c803dc1ebba709c96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.1/mise-v2026.8.1-linux-arm64.tar.gz"
      sha256 "bb2db7e82abaf0f9be1329056295ba6dc8745add3081c34b2913e23b96ae9bdb"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.1/mise-v2026.8.1-linux-x64.tar.gz"
      sha256 "c361c92d4b06b7ffc180592512c7c0e2a99b6ef7952710eef9ebc4ff1a1ac2c0"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
