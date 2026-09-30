class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.35.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.35.0/ollama-darwin.tgz"
      sha256 "2608dbb0a0f0136a198db9d48b4f74ece55f452314a39452fca35b7cf20c2589"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.35.0/ollama-darwin.tgz"
      sha256 "2608dbb0a0f0136a198db9d48b4f74ece55f452314a39452fca35b7cf20c2589"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.35.0/ollama-linux-arm64.tar.zst"
      sha256 "cb627d332b1fe5055bd5485ca10d595da8429e447648209e375390ec3bd09374"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.35.0/ollama-linux-amd64.tar.zst"
      sha256 "1c114a6b220c5efca2ef2b1e5f01d1e535e26f6cd6d1678c8489325d2835e525"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
