class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.12/mise-v2026.7.12-macos-arm64.tar.gz"
      sha256 "a73e15eb4974abf7c5c9445365e89cf2d8ec18afc97d4e161b317e65a404f261"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.12/mise-v2026.7.12-macos-x64.tar.gz"
      sha256 "e0986804aff135212cde044f6c5f7c4be3e7265640dfe79dc83bc1bebc392c4b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.12/mise-v2026.7.12-linux-arm64.tar.gz"
      sha256 "763f1bccf74f5c34f766a189a4a029a88d44b83f709e28af497ce2aae2704ead"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.12/mise-v2026.7.12-linux-x64.tar.gz"
      sha256 "81a05761cb901808bfae3e494e07ec80329eab66a49cd2fa7b8d9cd1ad96683d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
