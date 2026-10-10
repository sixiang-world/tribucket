class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.10.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.7/mise-v2026.10.7-macos-arm64.tar.gz"
      sha256 "5841e5ab5009b4c4dd2b641ddbfc6777cc1b9c9c0ffd375001e294540e9e9cc8"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.7/mise-v2026.10.7-macos-x64.tar.gz"
      sha256 "809b60fb1f7f5b8794db9c2ac78e5dc40df2e2a2e91d75e7dc97da1ecdc2755e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.10.7/mise-v2026.10.7-linux-arm64.tar.gz"
      sha256 "67bfc43bcc28de3a461b29fcf13a94a06019e4a1d3be37e4ff2c1347a576449b"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.10.7/mise-v2026.10.7-linux-x64.tar.gz"
      sha256 "3d31e3a53e8041b278ca999a4772d4575583098025384126e7aa8a31e0dac11c"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
