class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.1/mise-v2026.10.1-macos-arm64.tar.gz"
      sha256 "19b0ace2ffe420555d277c223f6eef252df3909f018c4faf1adf4a179b67c35a"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.1/mise-v2026.10.1-macos-x64.tar.gz"
      sha256 "70f0186533583e3e6bfc44b30b4497da10d5a5cfe487f23a642c21fb1e8d043c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.1/mise-v2026.10.1-linux-arm64.tar.gz"
      sha256 "15b7e978812d1657e615f42f366c4101f9d8733b96a85b12779a9f3f3e2d8596"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.1/mise-v2026.10.1-linux-x64.tar.gz"
      sha256 "9b92aa39b8fde54b28c8f974a68f2501925a1523d6c05a52719145df3acdd75a"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
