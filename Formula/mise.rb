class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.14/mise-v2026.8.14-macos-arm64.tar.gz"
      sha256 "e3ba526b629c41fa7b0918f78e746ca71a7a4b0c78dbfaca9fb25676a318762e"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.14/mise-v2026.8.14-macos-x64.tar.gz"
      sha256 "6085d0b7c7bf8e176397c48e3f1e2025bd41d69dd50f05c08cb7ae89fb7f77b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.14/mise-v2026.8.14-linux-arm64.tar.gz"
      sha256 "940639580227bd838e3b3ea5b2084ea397399b0db162c2e4dd90b5730850e48e"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.14/mise-v2026.8.14-linux-x64.tar.gz"
      sha256 "64d5f34aeb7a4e0e327dc1c9be66cd8162e14899a47b11901154a100285a3d61"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
