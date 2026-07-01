class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.31.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.31.1/ollama-darwin.tgz"
      sha256 "0c4f92389fcc1f651c17282e2eaffd68c8d3d06e1f7b307604102ad0e09a10c9"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.31.1/ollama-darwin.tgz"
      sha256 "0c4f92389fcc1f651c17282e2eaffd68c8d3d06e1f7b307604102ad0e09a10c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.31.1/ollama-linux-arm64.tar.zst"
      sha256 "47c82a67e59e060a735d1cb50a2acf020126a3a4be3f6847d5b58b7dd59620b6"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.31.1/ollama-linux-amd64.tar.zst"
      sha256 "d297381efc136451f6fabb9dd644a67f70fe51c16815a0c4a95ff0e327a3afb4"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
