class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.10/mise-v2026.8.10-macos-arm64.tar.gz"
      sha256 "ac6ed53215e70abfb220524aed121bf02dbd3fbd4a19355032dd1c5a108fb212"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.10/mise-v2026.8.10-macos-x64.tar.gz"
      sha256 "af65a35f95ee622c070c8ce5fe4984b58bb4ac20841c4ea1b82f7c3c2ae6defb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.10/mise-v2026.8.10-linux-arm64.tar.gz"
      sha256 "5fd8a9ffb312b47e29f642d377ad4fa9093962b47061ef5c15665086904e1046"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.10/mise-v2026.8.10-linux-x64.tar.gz"
      sha256 "e013fe11a0a9055fe78d2546baa85eba90a56e6445c431021b4fe328e6910fe2"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
