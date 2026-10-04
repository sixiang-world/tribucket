class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.2/mise-v2026.10.2-macos-arm64.tar.gz"
      sha256 "a3f67ff009f1436013eee37864c1c1855d9d9a9e4982a660b6495589635384e7"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.2/mise-v2026.10.2-macos-x64.tar.gz"
      sha256 "cc1497f6c370580d81d386004578f97d36b08031f6534818e0fd2756d54d0aca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.2/mise-v2026.10.2-linux-arm64.tar.gz"
      sha256 "5d3368679ce0cc37fb222511a04c61426cded69f0cda0f8248d03970dc34f303"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.2/mise-v2026.10.2-linux-x64.tar.gz"
      sha256 "79a2bf0ffc9b8a9a6391344e875b3c3679c15053fda3e8728ddf1790d63db788"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
