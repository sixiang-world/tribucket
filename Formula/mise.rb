class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.11/mise-v2026.10.11-macos-arm64.tar.gz"
      sha256 "64592e2978459d91b9dc690352c97d59a8c2b327f586fd201468fa56afe66311"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.11/mise-v2026.10.11-macos-x64.tar.gz"
      sha256 "6eaffe02521c700b420ba6930dfbc528951f27c1c9896c827ab6aab7248c75f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.11/mise-v2026.10.11-linux-arm64.tar.gz"
      sha256 "7534d514495449e267997410583833080ed0b99a0053f3b26a10691794a597b5"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.11/mise-v2026.10.11-linux-x64.tar.gz"
      sha256 "a7d0aad3d6782d42675fe0a2732b39bfc356f6cf2b554437f84c597814a2fd85"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
