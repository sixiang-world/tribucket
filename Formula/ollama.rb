class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.0/ollama-darwin.tgz"
      sha256 "3b12a49c6c4cbafd7ffba5ccba60cbf80274cdc22eea3ead79c646aba888174c"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.0/ollama-darwin.tgz"
      sha256 "3b12a49c6c4cbafd7ffba5ccba60cbf80274cdc22eea3ead79c646aba888174c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.0/ollama-linux-arm64.tar.zst"
      sha256 "2c1fbc47a5351c74f5400d7e4b1104bb470291af5d2f425c37c151487a477ad6"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.0/ollama-linux-amd64.tar.zst"
      sha256 "56362d7609dfa9e35aaebb7c9cab25605d8f0528ec3d5d585dc83d6642002bab"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
