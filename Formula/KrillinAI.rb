class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "2.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.1.0/KrillinAI-cli_2.1.0_macOS_arm64"
      sha256 "3fdf9d573ffd6fc717f63a09d227b62da80919b5efe11e5504d3ad44f7090930"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.1.0/KrillinAI-cli_2.1.0_macOS_amd64"
      sha256 "99f232430d58dd2bf35504afda2f037cb571ef010082a16e65cf5ae3861cd356"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.1.0/KrillinAI-cli_2.1.0_Linux_arm64"
      sha256 "3cbb5a71323a63d293031d91375c3d94f5ca31bf82f58b2fd27c0702058e9ed3"
    end
    on_intel do
      url "https://github.com/krillinai/KrillinAI/releases/download/v2.1.0/KrillinAI-cli_2.1.0_Linux_x86_64"
      sha256 "3f4e35af40d4ab4432e1bf9d40f8ab36c693631a90cd70946ee476034a571529"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
