class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.15/ollama-darwin.tgz"
      sha256 "607c79d5d6315ef9d896db83adde736a4c0057196329843544e79b95afb260a8"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.15/ollama-darwin.tgz"
      sha256 "607c79d5d6315ef9d896db83adde736a4c0057196329843544e79b95afb260a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.15/ollama-linux-arm64.tar.zst"
      sha256 "7f699ead5cdb4ae1ed89b888b148a238af188708800871e1889ab9dcee95f247"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.15/ollama-linux-amd64.tar.zst"
      sha256 "628c018404a4206493efd38e46251c154ede5141b8b8dc85c659b3b027c47379"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
