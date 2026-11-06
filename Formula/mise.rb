class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.11.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.3/mise-v2026.11.3-macos-arm64.tar.gz"
      sha256 "de9a54330fee4edede51a3cf6196bbf522f01c5e3fd981e0bebea33f561a0431"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.3/mise-v2026.11.3-macos-x64.tar.gz"
      sha256 "88389a4a624a7279ec8d2d06e5c0fbd874ce4f5de791767883b32f62f4e1d62c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.11.3/mise-v2026.11.3-linux-arm64.tar.gz"
      sha256 "13547a80d1dc2d5f81bb183023732f4981486e894d060e30993cc4364b4af51d"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.11.3/mise-v2026.11.3-linux-x64.tar.gz"
      sha256 "837acae6defb8c9ad74823f6e38856633bacb04c65c1ac67d952749847543bd9"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
