class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.8.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.6/mise-v2026.8.6-macos-arm64.tar.gz"
      sha256 "14ef21d1313d3b69986ac6976877d7ffb41df71f4fb9e8e4b57761cffaffca3b"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.6/mise-v2026.8.6-macos-x64.tar.gz"
      sha256 "925d242515338975071daab9e23bcf5803a0eafa2b8e9b4f78f61af5b4c865d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.8.6/mise-v2026.8.6-linux-arm64.tar.gz"
      sha256 "b92744ceb9a01f0bb198bfcf2ba49c36918c9e4353a34be50f23d5b6e93c28ee"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.8.6/mise-v2026.8.6-linux-x64.tar.gz"
      sha256 "cfe49784ec9683b38510846958cfecd9b59da84d4e8a38d18ffda19dc2941ead"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
