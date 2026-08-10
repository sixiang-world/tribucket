class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.7/ollama-darwin.tgz"
      sha256 "710b7c19f302385f125de6068865b7ba20457f85ef11160db3537ae588c710f3"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.7/ollama-darwin.tgz"
      sha256 "710b7c19f302385f125de6068865b7ba20457f85ef11160db3537ae588c710f3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.7/ollama-linux-arm64.tar.zst"
      sha256 "413cb50f2fd201b65e17e563c082607bc0ade60d700132c563c7a1c0cd529fde"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.7/ollama-linux-amd64.tar.zst"
      sha256 "ed1e39fe8fea90bd7f4c723bd949a2cea3153e111220ec0a183ea5b8dc8b2cae"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
