class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.10/mise-v2026.9.10-macos-arm64.tar.gz"
      sha256 "7d0c48e10a46a9cd6cf466303827cec34af6e5ed526c34d9348944eca9bcec99"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.10/mise-v2026.9.10-macos-x64.tar.gz"
      sha256 "6704c8986e60d1b03e3b2e95e88bc24b20e94bb762f26d6ec88755115638fc53"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.10/mise-v2026.9.10-linux-arm64.tar.gz"
      sha256 "efbfab6beaac07f933b63a95cb8746bbb7b2d48b70f636c19eb03a38f5786361"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.10/mise-v2026.9.10-linux-x64.tar.gz"
      sha256 "cf6c0d4713932cf47da67f4f753348bc1ccf9a22d4d1e3c76d3c23a6187a853c"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
