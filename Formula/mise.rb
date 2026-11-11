class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.6/mise-v2026.11.6-macos-arm64.tar.gz"
      sha256 "74cf55e92f6c6b1f166781c36db35db9420a4cbf40d62d85c1b9d5dc76e0ba72"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.6/mise-v2026.11.6-macos-x64.tar.gz"
      sha256 "052bf6eb24e5e813d42f6959f11340dba1c8e021b5cc7edda497c8d0c12d9948"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.6/mise-v2026.11.6-linux-arm64.tar.gz"
      sha256 "c5c90bea46cae89fd02d09a034e5e2d171abbbb313dab9baa833ee65a8cd996c"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.6/mise-v2026.11.6-linux-x64.tar.gz"
      sha256 "d6ebb6f5601bdf5a8d1d56028b24fe575f45075b989941ccc920f95161c5fa28"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
