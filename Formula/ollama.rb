class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.34.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.1/ollama-darwin.tgz"
      sha256 "f18fba83fb1eb415e143fb0c24372ebc4388fd7206f4927d4899932653e8c11d"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.1/ollama-darwin.tgz"
      sha256 "f18fba83fb1eb415e143fb0c24372ebc4388fd7206f4927d4899932653e8c11d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.1/ollama-linux-arm64.tar.zst"
      sha256 "b4bdbbbf5faf2fc15f9f6d775c984a33d5c6fee7b4fdeb3fb56612e58a172db9"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.1/ollama-linux-amd64.tar.zst"
      sha256 "f361dc3992ec07e4ad429f4bb2d10d4663ba2c295f9a9a688c7d52f4ba650034"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
