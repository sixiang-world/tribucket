class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.4/KrillinAI-CLI-3.2.4-mac-arm64.tar.gz"
      sha256 "4e4810c763041bf222e3e12450c988f3051e68b3f9114fac813f10acd2d05d34"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.4/KrillinAI-CLI-3.2.4-mac-x64.tar.gz"
      sha256 "c2f73518f49f1e2509f1a4af455cacc64f0876c0de250a68223b8b6c9197284a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.4/KrillinAI-CLI-3.2.4-linux-arm64.tar.gz"
      sha256 "73f74d3d1c1321b6385629ff218a64c4f630102507d467a1655ec2c262149aab"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.4/KrillinAI-CLI-3.2.4-linux-x64.tar.gz"
      sha256 "fa73e79e4aa4c6795a6d749afb2afe2b096be5af00c1492e31df1aa0c80cd9aa"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
