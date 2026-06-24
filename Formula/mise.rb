class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.6.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.13/mise-v2026.6.13-macos-arm64.tar.gz"
      sha256 "36478f14679e37ff38dfd3f238db6355dd5a90e1b3798b8a631d4574f46a280f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.13/mise-v2026.6.13-macos-x64.tar.gz"
      sha256 "846f8a104086565dcad1f6416e7aacf1b8a31031b5130c9280ec81ca21774f85"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.13/mise-v2026.6.13-linux-arm64.tar.gz"
      sha256 "a555743149405e87ad7da355e1c204a075671fb3cdbb196c9b4ef088f244b8ec"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.13/mise-v2026.6.13-linux-x64.tar.gz"
      sha256 "c6a9d10d0a12d224848f14733856b52e67d6664cc442cd519c75077de1e6f090"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
