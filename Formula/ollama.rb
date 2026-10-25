class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.11/ollama-darwin.tgz"
      sha256 "aea7d3f2e32371b7644a6e2ec8d4f26820a0e3965918cce8a46cef3e947f6291"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.11/ollama-darwin.tgz"
      sha256 "aea7d3f2e32371b7644a6e2ec8d4f26820a0e3965918cce8a46cef3e947f6291"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.11/ollama-linux-arm64.tar.zst"
      sha256 "77b278837b9e62c172f77d703675be4c52c8054e9075639031a9a6d5a53f1924"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.11/ollama-linux-amd64.tar.zst"
      sha256 "7bedab90dd122661be78798e9f0edf37fccf0cccf2699d2c58ea1a3afdc04b6d"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
