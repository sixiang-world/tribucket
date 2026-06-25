class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.6.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.14/mise-v2026.6.14-macos-arm64.tar.gz"
      sha256 "6d8d389bd729f5c44094a5d8e9df5c410acf4304e2540eb79a4854bdd22d0a91"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.14/mise-v2026.6.14-macos-x64.tar.gz"
      sha256 "da8f8872ba962d6893f0bab68b5a894caa296f1d17c2850ca407699441b44b26"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.14/mise-v2026.6.14-linux-arm64.tar.gz"
      sha256 "6d71ba01f20bb7cc7bfffac5214e9e788a08fa517c075eb955a5b31dca667ca7"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.14/mise-v2026.6.14-linux-x64.tar.gz"
      sha256 "c5bb4546ba2d5154e9c8236e2774bd8289b64c409330ed41cb6d6b8ebc31fb56"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
