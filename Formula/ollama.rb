class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.15/ollama-darwin.tgz"
      sha256 "9ab0ac4747946620a2464054f3c44a55aa146e9fccb5c366ee18e43fd1930b90"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.15/ollama-darwin.tgz"
      sha256 "9ab0ac4747946620a2464054f3c44a55aa146e9fccb5c366ee18e43fd1930b90"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.15/ollama-linux-arm64.tar.zst"
      sha256 "c898270b1690eab0f51aa9e9197686b7b4c6a7d88b83967763818f3127e477e9"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.15/ollama-linux-amd64.tar.zst"
      sha256 "50539c5fe9bf85887733355098dcdb266b433cb8c73fa180713417e9ed6e42bb"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
