class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.12/mise-v2026.10.12-macos-arm64.tar.gz"
      sha256 "6dc12b6087d4887cf807e9a9f3c2aa0ae0d90a6f465c6bd9c5d4a07847f88ab3"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.12/mise-v2026.10.12-macos-x64.tar.gz"
      sha256 "ddb347d57323cb418d01c2721838648f9b0288918ee4807df991cd87021c8b20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.12/mise-v2026.10.12-linux-arm64.tar.gz"
      sha256 "e6db9cd4cd45dfa0323080badb23db59951ce3cf077f54c691066735220085c6"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.12/mise-v2026.10.12-linux-x64.tar.gz"
      sha256 "aa5f8fbbb942296bbeea3769abf56c6f4ee37da4d203f0044b227cac4d929a87"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
