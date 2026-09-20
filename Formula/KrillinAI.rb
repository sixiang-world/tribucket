class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.1/KrillinAI-CLI-3.2.1-mac-arm64.tar.gz"
      sha256 "917e6a6e829f75b1c5deb45d59eb0dc48b1419bb747afb5f40f50d00069c8c04"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.1/KrillinAI-CLI-3.2.1-mac-x64.tar.gz"
      sha256 "3ab52aee0d2cc086f6c57dac365c24b6c89fcda0323223a10b8d5c174ecd1aff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.1/KrillinAI-CLI-3.2.1-linux-arm64.tar.gz"
      sha256 "a498f246f7930ac2afec32519ec3a82071d30235ef1c9e9582499d71732a3b6a"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.2.1/KrillinAI-CLI-3.2.1-linux-x64.tar.gz"
      sha256 "2a20f122eb780f945203cfd8ce78d75ce4a9e26ca54a1f4cd2d4a129a99749a3"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
