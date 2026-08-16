class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.14/ollama-darwin.tgz"
      sha256 "c7e8b91485943785bc6d295d96551e971ec94c6829d0d6b3500366942dc50cd1"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.14/ollama-darwin.tgz"
      sha256 "c7e8b91485943785bc6d295d96551e971ec94c6829d0d6b3500366942dc50cd1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.14/ollama-linux-arm64.tar.zst"
      sha256 "7802b739fbdc74df556600f1619f86457b69dce913301cf2d91f7f9d7f7a41b8"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.14/ollama-linux-amd64.tar.zst"
      sha256 "c620917a71e146ab3a7f893084f066069c4c65d144ef8379a91c3cbe8b27de8f"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
