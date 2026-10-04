class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.5/KrillinAI-CLI-3.2.5-mac-arm64.tar.gz"
      sha256 "e56a89ea56555bfd7d0bdab6cd9908472817e6b231c3165ae187554fa97640ad"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.5/KrillinAI-CLI-3.2.5-mac-x64.tar.gz"
      sha256 "92095b6fc65c8a3147398f2a5c204cfab5728909199b6df35e242da124d53f2a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.5/KrillinAI-CLI-3.2.5-linux-arm64.tar.gz"
      sha256 "1a6bd41539be03184e8ca41fb3d1011445db53cf488b8a3326161048c64b809f"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.5/KrillinAI-CLI-3.2.5-linux-x64.tar.gz"
      sha256 "3e7bfca33c01644cf34974966c7ba1a351706ff72aad39252247905f67b46e40"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
