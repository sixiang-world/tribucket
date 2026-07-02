class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.0/mise-v2026.7.0-macos-arm64.tar.gz"
      sha256 "23efe18046d12b95895d17b2bf0101a0efb9bf174767c57b6e2c8d019b964252"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.0/mise-v2026.7.0-macos-x64.tar.gz"
      sha256 "c33f2974806db45d5a2b0ab480d0750c54328c6fe87be5cf915106d46e55b9f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.0/mise-v2026.7.0-linux-arm64.tar.gz"
      sha256 "fcbba22dfd6bfaf94912fdba3e1f034c89841cda7a895fd2b7402cef3d7ae214"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.0/mise-v2026.7.0-linux-x64.tar.gz"
      sha256 "a3ff8f55b61504e7d7556d7b0cac4413e0c85ef7279545d2c2c3f49bd2cf8472"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
