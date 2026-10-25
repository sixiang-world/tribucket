class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.9/KrillinAI-CLI-3.2.9-mac-arm64.tar.gz"
      sha256 "280399c50ab73433f703c95bf01fe285966ea43ef1dcaa5efb68feeab30c5797"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.9/KrillinAI-CLI-3.2.9-mac-x64.tar.gz"
      sha256 "edbd2f88ae89253eba81943456dc91c2ec484ae7851bc9d1ef0cf2f48488ff32"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.9/KrillinAI-CLI-3.2.9-linux-arm64.tar.gz"
      sha256 "d9e70ef662542b626a14c139613cd99d6f55f13a0d094cb4f37ba6efbdb036cb"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.9/KrillinAI-CLI-3.2.9-linux-x64.tar.gz"
      sha256 "7e8781ea2121b3b6b27294868f2845ee684cbe727b4fe00bb3d5e7cb4282267e"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
