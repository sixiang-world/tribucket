class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.14/mise-v2026.7.14-macos-arm64.tar.gz"
      sha256 "7b2635ddc908e2b009cc8bf77daa24738eb2cf6fe611ced129b47bc407e3b9fe"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.14/mise-v2026.7.14-macos-x64.tar.gz"
      sha256 "5d21aa0a1e491260ddecb6aca07a5f5975d21e69eb6e3293df677f3722fcf2ba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.14/mise-v2026.7.14-linux-arm64.tar.gz"
      sha256 "c89a2aecf06566ea10bf3c90075588a2c69d07a1d7af428f9a111d910fd1d8b7"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.14/mise-v2026.7.14-linux-x64.tar.gz"
      sha256 "7a64615d0a594ac33a15632b0977e0a5b52a97d5d44691c63cb48397958163cf"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
