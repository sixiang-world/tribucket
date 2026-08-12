class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.5/mise-v2026.8.5-macos-arm64.tar.gz"
      sha256 "85983a9b88e36ba3211bcb4b2e5f81ea8d27708527d9100cde865e92f48a3ec2"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.5/mise-v2026.8.5-macos-x64.tar.gz"
      sha256 "1c44e614184f1a33cc95385c6189209b04e0b6fe8de851bdafd9d1807fd58dde"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.5/mise-v2026.8.5-linux-arm64.tar.gz"
      sha256 "25708951756ac7f732f98e03dccece8f38b644c8599aadb4dbc55c621e6ee868"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.5/mise-v2026.8.5-linux-x64.tar.gz"
      sha256 "f0de92940835ce6af5d0e1496daead7c4464c478046967341fab7d671d0a316b"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
