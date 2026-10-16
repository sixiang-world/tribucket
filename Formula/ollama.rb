class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.5/ollama-darwin.tgz"
      sha256 "75f9907dafa2fd4c61b5967de2ebb81ccc17eb28da9172edbad0dbc717474dcf"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.5/ollama-darwin.tgz"
      sha256 "75f9907dafa2fd4c61b5967de2ebb81ccc17eb28da9172edbad0dbc717474dcf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.5/ollama-linux-arm64.tar.zst"
      sha256 "fbe71ebb1a10e59b8480c4d2839826b5f9dff1a6d5c142428b2e7db9b1a2c642"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.5/ollama-linux-amd64.tar.zst"
      sha256 "dc5eabc292f9949546c90a97c820f924b035e05243b0de13c7f366182562169c"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
