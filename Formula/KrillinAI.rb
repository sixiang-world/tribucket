class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.3.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.4/KrillinAI-CLI-3.3.4-mac-arm64.tar.gz"
      sha256 "977ae015bd79a0c798e20f4f0805cbd96a374a02fdda60603c223b130b80e657"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.4/KrillinAI-CLI-3.3.4-mac-x64.tar.gz"
      sha256 "5b8caf265a075b6fa6f6424fba51c463168707dc60a6d48018fb095c3e24ed39"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.4/KrillinAI-CLI-3.3.4-linux-arm64.tar.gz"
      sha256 "97e3816556c21399812c5e37481d7cbcefc3c09fee77961860c3acff1e84ea6e"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.4/KrillinAI-CLI-3.3.4-linux-x64.tar.gz"
      sha256 "e15f8f777ed61c932916bd44adb235dd86b4fc851ab1ecaafc37ea843b3c0e40"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
