class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.3.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.3/KrillinAI-CLI-3.3.3-mac-arm64.tar.gz"
      sha256 "63d0038c643779e07c0b989965d92f46720d85f21edd130b4a02679258528feb"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.3/KrillinAI-CLI-3.3.3-mac-x64.tar.gz"
      sha256 "5651448f243abf34e24aa4dda2f5fc41da95026e72c3057d7be5bbfce09ce789"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.3/KrillinAI-CLI-3.3.3-linux-arm64.tar.gz"
      sha256 "18132b237b5397ec8b7a98821f32b5417607c530ff08d741a76fbdc0d7dfee5b"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.3/KrillinAI-CLI-3.3.3-linux-x64.tar.gz"
      sha256 "16c4c060a29abb06bcf070c7cd272f152eab0cc2f9b1c1deb7a4a8761fe08f65"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
