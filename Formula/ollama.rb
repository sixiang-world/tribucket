class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.33.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.1/ollama-darwin.tgz"
      sha256 "6c4ff73ee47b1d8971cf80df3b7db4fc4284cfcdffdfe09c014e12cd72bacf83"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.1/ollama-darwin.tgz"
      sha256 "6c4ff73ee47b1d8971cf80df3b7db4fc4284cfcdffdfe09c014e12cd72bacf83"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.1/ollama-linux-arm64.tar.zst"
      sha256 "869b98629bf4a438d1c11669331c8214e8317cdfd7ec3fe4efd44fb929602f57"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.1/ollama-linux-amd64.tar.zst"
      sha256 "88e0d36bd90121595e5516c84f6ab61b546368fbd2d825b4aae70999c949649d"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
