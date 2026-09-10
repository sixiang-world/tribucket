class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.34.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.0/ollama-darwin.tgz"
      sha256 "dd12b00bcce2d6551178e67ada90d5af9f75bdb54a118b96655250fa3e8ef734"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.0/ollama-darwin.tgz"
      sha256 "dd12b00bcce2d6551178e67ada90d5af9f75bdb54a118b96655250fa3e8ef734"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.0/ollama-linux-arm64.tar.zst"
      sha256 "6a9e5b3650c2024d8a78da86b23876f6eea238657a3262d7e5ec0f3688c5d28e"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.0/ollama-linux-amd64.tar.zst"
      sha256 "cf95886728959aa09910bb34de5cca1cc5a8f68003b5597197d3f2c2d57c0804"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
