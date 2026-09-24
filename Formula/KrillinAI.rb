class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.3/KrillinAI-CLI-3.2.3-mac-arm64.tar.gz"
      sha256 "aaea232710b1c3962930ef355f8d3a3ec142d882e8f89b2826a7438182d52a7a"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.3/KrillinAI-CLI-3.2.3-mac-x64.tar.gz"
      sha256 "52e79d2be5f72d66ccf1f9cc8e7049f335b1d20d0931391ea301cd4b75f2e9fc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.3/KrillinAI-CLI-3.2.3-linux-arm64.tar.gz"
      sha256 "885865ba5e8f9baa26085b7059ff6ea212c4abdc443c72078d41f03ab91a9253"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.3/KrillinAI-CLI-3.2.3-linux-x64.tar.gz"
      sha256 "0a181094a794444cca45a8dd50e5ce11cf55a4c970db3a5b1947745788658175"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
