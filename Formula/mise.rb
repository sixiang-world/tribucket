class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.11/mise-v2026.8.11-macos-arm64.tar.gz"
      sha256 "f187648d2350b41cee4cebc6bb1b541cc3a3bf9144a91be028c73733c725e18b"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.11/mise-v2026.8.11-macos-x64.tar.gz"
      sha256 "9199be9339bb8a34a44c1e35fd24b5662051abe24c4527c51bdedba2807fbe98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.11/mise-v2026.8.11-linux-arm64.tar.gz"
      sha256 "6b93eed2f4993be9574ba29a61287bbd2a8a3c2e59e57af8e05556a8b6208d12"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.11/mise-v2026.8.11-linux-x64.tar.gz"
      sha256 "8eb73e0225fcb80f48c312434ce04a334c95b92fb4a4dc1cf4a231af18497dc3"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
