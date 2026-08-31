class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.16/mise-v2026.8.16-macos-arm64.tar.gz"
      sha256 "cdda357066d138ebe8336cdf6b21134bb771175aced99ae89b48b4d59417d59a"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.16/mise-v2026.8.16-macos-x64.tar.gz"
      sha256 "77fbc1f861e44781027cdbfef78f4f66497170c1ed014b6f79bd662303d8826a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.16/mise-v2026.8.16-linux-arm64.tar.gz"
      sha256 "bf7c2c3fa91459cbc1d4b1b70d8bf6d86c1372b97e5f4529682bccf9f03cbbb0"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.16/mise-v2026.8.16-linux-x64.tar.gz"
      sha256 "0545eca5bc01843bb3f89b58d995b81ff345d579de23f7fbe109a5e6ca653b7d"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
