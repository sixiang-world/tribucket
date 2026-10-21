class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.7/ollama-darwin.tgz"
      sha256 "6c8b378e423a4c959b586c0bb62865d20ae057e817f1a8ee10abcc44bde6abab"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.7/ollama-darwin.tgz"
      sha256 "6c8b378e423a4c959b586c0bb62865d20ae057e817f1a8ee10abcc44bde6abab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.7/ollama-linux-arm64.tar.zst"
      sha256 "c74249e87795b1437ce0f484adfd05b4628d7497472c475b13ec6db69ecc69cf"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.7/ollama-linux-amd64.tar.zst"
      sha256 "7f082e625b4c334df84ed1558fe282d6d8091fe3545790aef30b3a9c50d44d41"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
