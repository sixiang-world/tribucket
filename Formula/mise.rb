class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.6.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.11/mise-v2026.6.11-macos-arm64.tar.gz"
      sha256 "084c352a9c5d1a19bd31fef84ba9692952aa04e8d2e3fe666948db35dedfaf95"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.11/mise-v2026.6.11-macos-x64.tar.gz"
      sha256 "1fa07237cdfa6f7cf7d56914501a2fa10b8f89a5f0ac2036948efca6e11de8db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.11/mise-v2026.6.11-linux-arm64.tar.gz"
      sha256 "0318f90fccf8bad6547ad6b2191764233309ceb3b6cece94c48454f385f091f5"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.11/mise-v2026.6.11-linux-x64.tar.gz"
      sha256 "89c88e407c6e3a19f5f86af2cbbf88c6ef6147d55a7098c84da12b36f44f1ff3"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
