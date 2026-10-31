class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.25"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.25/mise-v2026.10.25-macos-arm64.tar.gz"
      sha256 "774236e3247e48d78078c0bce79e5327d4e4479f1a94c8487827f178197ee39b"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.25/mise-v2026.10.25-macos-x64.tar.gz"
      sha256 "2b31afc1ef77c46bf9cb0837dba9366ad744f452343a0f8b00d3df1eef892f84"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.25/mise-v2026.10.25-linux-arm64.tar.gz"
      sha256 "a7d1e2add53441ff76e7e971e7a3fb15c117741836ce51c026f5fb7eebe7dbcf"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.25/mise-v2026.10.25-linux-x64.tar.gz"
      sha256 "199966edaad1b208eb4c72955f1722dafb8fa799f575db720dea05aaa8216546"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
