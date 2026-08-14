class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.12/ollama-darwin.tgz"
      sha256 "481e2339b9fa330ec3c94bc642e5d235a3da36e7db48510b0b01990b3c69393c"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.12/ollama-darwin.tgz"
      sha256 "481e2339b9fa330ec3c94bc642e5d235a3da36e7db48510b0b01990b3c69393c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.12/ollama-linux-arm64.tar.zst"
      sha256 "9dacd3525e9295ed3f7d44d742154a42901c6148c82662390951a26a62f1316f"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.12/ollama-linux-amd64.tar.zst"
      sha256 "4fddeff70f58a503e73d4678d1f8756ecff72fbaa740e0d14c1ab17c560c5e83"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
