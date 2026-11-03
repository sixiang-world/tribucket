class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.0/KrillinAI-CLI-3.3.0-mac-arm64.tar.gz"
      sha256 "6e99d07085bac2dac803efe2e570ecc83b7fd08b8e99a8b5e8c1cf78d41c9ae4"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.0/KrillinAI-CLI-3.3.0-mac-x64.tar.gz"
      sha256 "b5d67daf92fa8da9712d3da23bbdd819ebb3739af5294bc2da00ce2b563d3062"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.0/KrillinAI-CLI-3.3.0-linux-arm64.tar.gz"
      sha256 "a0c8c0a0bca15ef78bc90c07775396321c677afc1857efcb7d9a411261a6bf11"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.0/KrillinAI-CLI-3.3.0-linux-x64.tar.gz"
      sha256 "b9d38c21ccfe008df2a81c747e8d149bc7876c99aecd06c2cffc895b9845a7dc"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
