class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.2/ollama-darwin.tgz"
      sha256 "e888b7637291ceb80b622c00ea067f62c86d9c50d419b3eb903032e4f1f8a4f6"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.2/ollama-darwin.tgz"
      sha256 "e888b7637291ceb80b622c00ea067f62c86d9c50d419b3eb903032e4f1f8a4f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.2/ollama-linux-arm64.tar.zst"
      sha256 "92b3ef3d5e10f5849273bfa1345000f2a8ce8bc834e95061ff5b9df5d08e3c3f"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.2/ollama-linux-amd64.tar.zst"
      sha256 "726bee78706c281b0eeef00746efe51a044d71c592c3f0b195820707f31fdf04"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
