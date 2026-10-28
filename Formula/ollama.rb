class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.12/ollama-darwin.tgz"
      sha256 "1d1b4c2cf40d2a239f9b08a77384830800a8542c744a55f47247f9baf85b55d2"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.12/ollama-darwin.tgz"
      sha256 "1d1b4c2cf40d2a239f9b08a77384830800a8542c744a55f47247f9baf85b55d2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.12/ollama-linux-arm64.tar.zst"
      sha256 "eab411c311611fe0fcddf5ba73c68ea94a9571007b520d8708112348b87c0bd6"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.12/ollama-linux-amd64.tar.zst"
      sha256 "f8adcb7e08d272283a4bd3abc18cf581afe37e64b2aee04fda4f407f215485ba"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
