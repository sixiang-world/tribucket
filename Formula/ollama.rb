class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.1/ollama-darwin.tgz"
      sha256 "66e1587711f3a06315b23782ba74897001da6c8b8edf6c0371f7533015a076dd"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.1/ollama-darwin.tgz"
      sha256 "66e1587711f3a06315b23782ba74897001da6c8b8edf6c0371f7533015a076dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.1/ollama-linux-arm64.tar.zst"
      sha256 "f5cbd9a97e0de9502ef928cb993f6d16468e25be6d55a8529d7fd2b67a130bcb"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.1/ollama-linux-amd64.tar.zst"
      sha256 "a7aebbe3dd76ccf1351a56a3e57218ad4863cb5f9a9938c58de87a37555e355d"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
