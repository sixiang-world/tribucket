class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.21"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.21/mise-v2026.10.21-macos-arm64.tar.gz"
      sha256 "d67b6006cb1144131910ce80d6cf52134f55b9c7da55648bd717df36b3f238d6"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.21/mise-v2026.10.21-macos-x64.tar.gz"
      sha256 "722848fc0522a996bccca35ceef614b3926bb1ae97b145fe11bb08cf960b31f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.21/mise-v2026.10.21-linux-arm64.tar.gz"
      sha256 "1c05e4d4baaf1b4a9bf929e9c39b3512deb937c8d4c1bd52927499624018834f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.21/mise-v2026.10.21-linux-x64.tar.gz"
      sha256 "f56cc56b462eaae60aa7a33dffd24f641847b52e098b69e4a5064c4b8bbe03cb"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
