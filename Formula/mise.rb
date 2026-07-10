class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.5/mise-v2026.7.5-macos-arm64.tar.gz"
      sha256 "ae0c21532774eda198b23a22a7ffbe684f482c074a976a13e0f664af8255e2ae"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.5/mise-v2026.7.5-macos-x64.tar.gz"
      sha256 "48cc4ae352bd903d5069e9967ebba18dfb0bbd46aa325a82a353b07329ebf57d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.5/mise-v2026.7.5-linux-arm64.tar.gz"
      sha256 "9020f7453931a6873d60cf204d5935ebd08633b25f675b0820cd06862b4b6450"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.5/mise-v2026.7.5-linux-x64.tar.gz"
      sha256 "be92da3afb180dc71b3ce6fcaaaf2f393812c9c50e9a64c9cb6706cf28edb486"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
