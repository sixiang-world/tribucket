class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.6/KrillinAI-CLI-3.2.6-mac-arm64.tar.gz"
      sha256 "fd4a4588d50f320aaed1a09ca6e9508969e85abea1239df73c40ce80118eb112"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.6/KrillinAI-CLI-3.2.6-mac-x64.tar.gz"
      sha256 "9ffaef1ca9e42f5572ee9708bce17f1983b0f843084d9a5eb65b4e10429a508c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.6/KrillinAI-CLI-3.2.6-linux-arm64.tar.gz"
      sha256 "39e5c0feaa6ba2fd2b077e3b70059a86c50e06c34cd334b922ae0e011a523c91"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.6/KrillinAI-CLI-3.2.6-linux-x64.tar.gz"
      sha256 "2e25ed459ef04422c05334e8b8bd81371162091d76a5ef63313d75cb0d2eff33"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
