class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.9.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.2/mise-v2026.9.2-macos-arm64.tar.gz"
      sha256 "d317070f13bd6f588864c3f7bbbaf9d63c9c28b48ebf0fddcbc1f5272294671d"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.2/mise-v2026.9.2-macos-x64.tar.gz"
      sha256 "a9711067921663a849439912d1a3b4d58d06d430919f3c7383fc1675e687c9c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.9.2/mise-v2026.9.2-linux-arm64.tar.gz"
      sha256 "0f0068f32dbd1e52c9c3a7315bbc119e12ec750441d9061e135f9ad6a534e2f6"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.9.2/mise-v2026.9.2-linux-x64.tar.gz"
      sha256 "3c149f1782afef46b5fe76918e03000658b97cc92a63332a5349c26c46ed3780"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
