class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.7/mise-v2026.7.7-macos-arm64.tar.gz"
      sha256 "df490dc2fff51c82bf0f64e1fcd0265b145ce80d2d15ce99b95f2adf0b1fe82c"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.7/mise-v2026.7.7-macos-x64.tar.gz"
      sha256 "58f4fea2a673b979e98f245e7a73e122b2960989c049dba04980ea13002ada2a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.7/mise-v2026.7.7-linux-arm64.tar.gz"
      sha256 "c4e542b53a15d2ec641e072f7b2d9da8a0554b92fd2c09a51febde32c6080ab8"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.7/mise-v2026.7.7-linux-x64.tar.gz"
      sha256 "0953810c2785eb4a75159f67f8b5721c4f3c80b8a6a812015d5af7d7fbd1b8a4"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
