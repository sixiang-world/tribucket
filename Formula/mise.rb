class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.1/mise-v2026.7.1-macos-arm64.tar.gz"
      sha256 "27dc32b38623a458166b8098625babba55850ec9598e9df9c2845b58a0e07bdf"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.1/mise-v2026.7.1-macos-x64.tar.gz"
      sha256 "00a17c5e7030e997f551c4b366aafea136e86d2a6305d63b2634ab4597e32682"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.1/mise-v2026.7.1-linux-arm64.tar.gz"
      sha256 "9dee702209140282d41056db483370a311ce91c9f560d6b29a09ae475be66d07"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.1/mise-v2026.7.1-linux-x64.tar.gz"
      sha256 "4a504fc40c6a6bb61810e22ebdaa1dfe664b366623600d6382dbab963d655583"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
