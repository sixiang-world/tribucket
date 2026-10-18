class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.8/KrillinAI-CLI-3.2.8-mac-arm64.tar.gz"
      sha256 "e1be49bdfcda5857b8e8f16c47a9894f68f626496d649829e47e4f33e5e151cd"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.8/KrillinAI-CLI-3.2.8-mac-x64.tar.gz"
      sha256 "90f3d834ab0f47f550327990fa5c95ae59eccfe0b0889556335f68107b3cb5d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.8/KrillinAI-CLI-3.2.8-linux-arm64.tar.gz"
      sha256 "1d3e9d93c060ed8e6b226fbe18bc75cd20446dfa556f55679f5b063321701928"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.8/KrillinAI-CLI-3.2.8-linux-x64.tar.gz"
      sha256 "531b6b2313ebade40d299cd6593f5af0eecc474fe0ffeb809770170474f22c06"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
