class Mise < Formula
  desc "Polyglot runtime manager (asdf replacement)"
  homepage "https://github.com/jdx/mise"
  version "2026.7.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.2/mise-v2026.7.2-macos-arm64.tar.gz"
      sha256 "cb396a67720423503011e380929aec29d8d197a6d5b226cf0ff0dda6a04ef172"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.2/mise-v2026.7.2-macos-x64.tar.gz"
      sha256 "e94bdbd0b306b59c5a232e70d6fca10bfc8f72c163aa6b1a41baf251a83f0ffb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jdx/mise/releases/download/v2026.7.2/mise-v2026.7.2-linux-arm64.tar.gz"
      sha256 "ebecbe18d4c2cfa06f33f9b13838811171188becdb01266354804faeaca5000b"
    end
    on_intel do
      url "https://github.com/jdx/mise/releases/download/v2026.7.2/mise-v2026.7.2-linux-x64.tar.gz"
      sha256 "5bf4b0bb89c4973cf59c9b72cde25a55b57f271917e50dd4e25ab8acf9ac289a"
    end
  end

  def install
    bin.install Dir["mise*"].first => "mise"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mise --version 2>&1", 1)
  end
end
