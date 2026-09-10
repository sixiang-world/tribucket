class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.4/mise-v2026.9.4-macos-arm64.tar.gz"
      sha256 "989fa96f2c9eba80e0cc35b0887d69b8f5b25c17f54bc8676aa520e93450425f"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.4/mise-v2026.9.4-macos-x64.tar.gz"
      sha256 "5f3105599177b11530b29af7a3fd1e89ef2f21cecb01e54e4aebb6f62ac0c78c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.4/mise-v2026.9.4-linux-arm64.tar.gz"
      sha256 "18303fdb59095acf0c50b0d23819b87182516988f9eb2ec016b52f8814916904"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.4/mise-v2026.9.4-linux-x64.tar.gz"
      sha256 "2f4489c8e57e7d0fc1ad155691bacac5ed0c613c5e3acec2e42ecad8ace5ce3f"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
