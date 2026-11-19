class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.10/mise-v2026.11.10-macos-arm64.tar.gz"
      sha256 "0ff163f78007130393ed5303aad06bc5e793c0bd298bc77eeb5913a3748e1922"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.10/mise-v2026.11.10-macos-x64.tar.gz"
      sha256 "905109ce3c28aad7fd62a1a6735d5f3c27e6f0c6be28b35768b30b5fe4a1c707"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.10/mise-v2026.11.10-linux-arm64.tar.gz"
      sha256 "af305e1efc58433a79b893738bfbf11b4b1662bdea9f0ea71f2ecab990058ad6"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.10/mise-v2026.11.10-linux-x64.tar.gz"
      sha256 "70a3cf7776ea97cfdae0b4c49ef348782c454b43b0bb77823cf029840c332946"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
