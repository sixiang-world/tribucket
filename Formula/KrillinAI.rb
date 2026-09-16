class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.0/KrillinAI-CLI-3.2.0-mac-arm64.tar.gz"
      sha256 "307da4b46dee231712fa5cd62fb787eb91dcea331997038f73a2356939fcafd5"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.0/KrillinAI-CLI-3.2.0-mac-x64.tar.gz"
      sha256 "6e53957562842e4bebf903d5d577568ab0470ce97babf51dc96e17758e3c558d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.0/KrillinAI-CLI-3.2.0-linux-arm64.tar.gz"
      sha256 "493d94086fc245748e32017b1c24da13fe38e2162b6005c77952a68b2e9a7f7b"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.0/KrillinAI-CLI-3.2.0-linux-x64.tar.gz"
      sha256 "1a55ee9532479f799592728dfee1d12b17a64e6c0a237cb551de0bbe3677ca2d"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
