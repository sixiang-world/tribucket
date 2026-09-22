class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.34.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.3/ollama-darwin.tgz"
      sha256 "2c45865f94bce0d4d1d2567603dd2fdacaf375585220a175aa4800105193d36e"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.3/ollama-darwin.tgz"
      sha256 "2c45865f94bce0d4d1d2567603dd2fdacaf375585220a175aa4800105193d36e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.3/ollama-linux-arm64.tar.zst"
      sha256 "cb1d3c178d48b302dbe42b4fb0ce25ef6282e02eac25496cfc07f5333e2264dd"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.3/ollama-linux-amd64.tar.zst"
      sha256 "e83a089fd0cd2f79ee2933cca2085846a2065f497adbc6467c402177c68423f9"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
