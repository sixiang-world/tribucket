class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.11/ollama-darwin.tgz"
      sha256 "48ec3dc8053a63031eb7c49a4901c36420fb52d6db5b56e388bf7c989cd16cc1"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.11/ollama-darwin.tgz"
      sha256 "48ec3dc8053a63031eb7c49a4901c36420fb52d6db5b56e388bf7c989cd16cc1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.11/ollama-linux-arm64.tar.zst"
      sha256 "e6c67017ac5c7f93f3f6a5a5f7f8377677b6378a4c5c36ca6ccb221429b38bb8"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.11/ollama-linux-amd64.tar.zst"
      sha256 "873258110663ff4e72bed8549b9e86589e1c07d99646cac257b71a4a6a72dcc7"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
