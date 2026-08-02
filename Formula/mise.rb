class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.0/mise-v2026.8.0-macos-arm64.tar.gz"
      sha256 "94ee46ec22b05560728b89d22792cb51cdd01c174911c0795989d19e3212311a"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.0/mise-v2026.8.0-macos-x64.tar.gz"
      sha256 "4dba3fb509d72c955e95e552aee9130574f4003af84f34da98eeb3655603bd35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.0/mise-v2026.8.0-linux-arm64.tar.gz"
      sha256 "6d888ba3d0b5d78f676771a84846885b7f685fb4d1533f2927079eb9b75633a8"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.0/mise-v2026.8.0-linux-x64.tar.gz"
      sha256 "64183603854f319b78658305c545aacae935e0959a3a894b77a0f9416eab047b"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
