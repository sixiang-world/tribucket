class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.16/mise-v2026.9.16-macos-arm64.tar.gz"
      sha256 "ce340c6c4bfd4b515557062276184a4b2be4aeec4120173b017bb1179414de88"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.16/mise-v2026.9.16-macos-x64.tar.gz"
      sha256 "12eabbec662f87fbe8e39bd5e2cc5b0796cd18ebf58cf5ad41fef981c6757d51"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.16/mise-v2026.9.16-linux-arm64.tar.gz"
      sha256 "a19097ac76225b3ebe78b1a93ad302f1fe3e6fa9f40edf724deb3b83244bb7ff"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.16/mise-v2026.9.16-linux-x64.tar.gz"
      sha256 "2e022482d62a3b9e6c0bc51d3e883401bfa7e4684b60f3b819b21eae4ebdb438"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
