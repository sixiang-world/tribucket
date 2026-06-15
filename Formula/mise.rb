class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.6.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.10/mise-v2026.6.10-macos-arm64.tar.gz"
      sha256 "44ebccf53eab0843716f73be8c3e10c7b57706bc72f54f87146e5d7c91b4b0fd"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.10/mise-v2026.6.10-macos-x64.tar.gz"
      sha256 "92f4d52e12a1ca12c9aa80bd2f01e8f832a580adc35e14bc292eb1421f4fb770"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.6.10/mise-v2026.6.10-linux-arm64.tar.gz"
      sha256 "64825f69d63bcf1156f6764ca58f521cf5223009643b440a130a0f136fd26d00"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.6.10/mise-v2026.6.10-linux-x64.tar.gz"
      sha256 "472e01b40cd35da6178e8e41e213473286f0562b93a14e47d3e847f5035d13af"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
