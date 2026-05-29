class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.5.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.5.16/mise-v2026.5.16-macos-arm64.tar.gz"
      sha256 "761bb3a68627685050fd641d3afdc2d2a2df605b734f7a5566a79b5c609c64f0"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.5.16/mise-v2026.5.16-macos-x64.tar.gz"
      sha256 "f4a7a6a8d34a8689c62378c1bd13be4f37c7ea399799687c19cf93c2ffca9845"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.5.16/mise-v2026.5.16-linux-arm64.tar.gz"
      sha256 "00f94d934a957c67f083669003bc0fd9e6009aec5aa8c6f1649c376f115b3818"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.5.16/mise-v2026.5.16-linux-x64.tar.gz"
      sha256 "43c37041c8d5ba3fd1353c3244f2f346866b76f1bafb6c57f059678e1c7a4046"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
