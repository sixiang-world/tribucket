class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.33.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.0/ollama-darwin.tgz"
      sha256 "63e05ad537bc02a9ee790345341ca1aff7803d289fdd4f5fda065190a2087124"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.0/ollama-darwin.tgz"
      sha256 "63e05ad537bc02a9ee790345341ca1aff7803d289fdd4f5fda065190a2087124"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.0/ollama-linux-arm64.tar.zst"
      sha256 "c09f5ae1fc90f70ac6e19e325bd958d9c8c02c29ec0908785c21672fab5f4ee4"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.0/ollama-linux-amd64.tar.zst"
      sha256 "72c4b9d91c317742ffd11b92e0a7fbe6353072c6354d910f1a03fd3ce40403d4"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
