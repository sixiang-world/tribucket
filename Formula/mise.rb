class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.15/mise-v2026.10.15-macos-arm64.tar.gz"
      sha256 "8a44a56f72323c777298a1d5abd88ffd21d0fca19fab1ccccd389a912374f69c"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.15/mise-v2026.10.15-macos-x64.tar.gz"
      sha256 "237d529785538eddc3c2243220f3e63e5012d73fc23f1616c05f4c27a1291bbd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.15/mise-v2026.10.15-linux-arm64.tar.gz"
      sha256 "ae36e72ea72d337ab7b367edb0f7016fa1502aa0e36ccb705acad7902c60677b"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.15/mise-v2026.10.15-linux-x64.tar.gz"
      sha256 "1c2d85dc42bef51e0bb20780093c746d6e12dfd15ca461f3979bd52cc214bc19"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
