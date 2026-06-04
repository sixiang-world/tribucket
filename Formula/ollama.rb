class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.5/ollama-darwin.tgz"
      sha256 "1defa6bfac03cdc2c3e996a1b79b69eb4eb7d711b5aeb623001497b37a3de41b"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.5/ollama-darwin.tgz"
      sha256 "1defa6bfac03cdc2c3e996a1b79b69eb4eb7d711b5aeb623001497b37a3de41b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.5/ollama-linux-arm64.tar.zst"
      sha256 "12da8c15e4c397bacaf1a509456e4a8662b72ed97938d7d63affe10a34f9ca89"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.5/ollama-linux-amd64.tar.zst"
      sha256 "36d104f9b9e318d0f742e2291f553ee40791b5f0a7b866e3a896eecd789568b6"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
