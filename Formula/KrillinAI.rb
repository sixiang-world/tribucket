class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "2.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.2/KrillinAI-cli_2.0.2_macOS_arm64"
      sha256 "81f4214460649df454f0095daf75cc754008515d647f63bfd2c775b12fd00d10"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.2/KrillinAI-cli_2.0.2_macOS_amd64"
      sha256 "5650f5f47f7c49f4ba25f5e051390de429f479f81abb169ce04f5c104462d0fe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.2/KrillinAI-cli_2.0.2_Linux_arm64"
      sha256 "cbbb8b4285f66f8baec8443b06ade0787d7c166f7e21fdd1594b0e5c8ba419fe"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.0.2/KrillinAI-cli_2.0.2_Linux_x86_64"
      sha256 "ad7d61abeee8d64c7b5a97763f068175751cbbd552ad5ebb3be2ff2ac0578b21"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
