class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.6/ollama-darwin.tgz"
      sha256 "b2b55434865a668decb494110d7fd970eed3ecc8837be2872f672ccbb95df974"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.6/ollama-darwin.tgz"
      sha256 "b2b55434865a668decb494110d7fd970eed3ecc8837be2872f672ccbb95df974"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.6/ollama-linux-arm64.tar.zst"
      sha256 "0a279d9428ad17b06fdb7dddf3b059b2c148433585fa3b30676a102fc459bb9f"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.6/ollama-linux-amd64.tar.zst"
      sha256 "c164ab8b1b28e2a247c29719b8e404c423c5b83ae64c3ab4e59d50c7ff7fc5e0"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
