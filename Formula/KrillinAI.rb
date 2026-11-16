class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.2/KrillinAI-CLI-3.3.2-mac-arm64.tar.gz"
      sha256 "f8eb41fa5298500e4dc0ce55e68469da58544412e8897384529d3daa74a171ed"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.2/KrillinAI-CLI-3.3.2-mac-x64.tar.gz"
      sha256 "342a810a8e3da609a7e3a9c4e9a45361595ccf4274afb6fc011e7c18a8caa22a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.2/KrillinAI-CLI-3.3.2-linux-arm64.tar.gz"
      sha256 "ec197ac979b41013a2d405635f1ca7e57e2fdac47fea965bdc1d3b042362e491"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.2/KrillinAI-CLI-3.3.2-linux-x64.tar.gz"
      sha256 "e96d32125fa5278298e68ebbb3be6268896771ee1a0af76641e0e3b72d4da6ac"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
