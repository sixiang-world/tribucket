class Krillinai < Formula
  desc "AI video translation and dubbing tool powered by LLMs"
  homepage "https://github.com/KrillinAI/KrillinAI"
  version "3.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.1/KrillinAI-CLI-3.3.1-mac-arm64.tar.gz"
      sha256 "2606a20bbd9e7093cdba551f77b41db7801ea15a3a63c65256c26e3511b96a3a"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.1/KrillinAI-CLI-3.3.1-mac-x64.tar.gz"
      sha256 "0bf149f5c9960909dcce2ea828ecbd801f4b2b929cd3bc4de220a4d86fb8c86b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.1/KrillinAI-CLI-3.3.1-linux-arm64.tar.gz"
      sha256 "d9b3620e52f7eb331d4cbb5ea51f6be27f142606a36e503a43330d2766ed46a9"
    end
    on_intel do
      url "https://github.com/krillinai/OpenCreator/releases/download/v3.3.1/KrillinAI-CLI-3.3.1-linux-x64.tar.gz"
      sha256 "a493dab79ee22d3210a9eec33abc73293bfe0de79fd33cb42572cb64211dc882"
    end
  end

  def install
    bin.install Dir["KrillinAI-cli*"].first => "KrillinAI-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/KrillinAI-cli --version 2>&1", 1)
  end
end
