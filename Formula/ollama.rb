class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.4/ollama-darwin.tgz"
      sha256 "fa36a0e6fbf5716a5cc85ad15454862a987adbc2bed9e9ef82f1e9d77e082554"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.4/ollama-darwin.tgz"
      sha256 "fa36a0e6fbf5716a5cc85ad15454862a987adbc2bed9e9ef82f1e9d77e082554"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.4/ollama-linux-arm64.tar.zst"
      sha256 "877981499ab2ccc8ffd674a5c2fe1788ebd67a4c31df8d399fca3a488072e551"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.4/ollama-linux-amd64.tar.zst"
      sha256 "78e317889c907d9853336c8d834f424c7dc6ccd8958772f44fadf78f421ea907"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
