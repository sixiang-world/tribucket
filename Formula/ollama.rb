class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.24.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.24.0/ollama-darwin.tgz"
      sha256 "e6d5e8b4bc0cb2a35ff7901c58d81ca2170403a819c4726f58798155fa682e38"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.24.0/ollama-darwin.tgz"
      sha256 "e6d5e8b4bc0cb2a35ff7901c58d81ca2170403a819c4726f58798155fa682e38"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.24.0/ollama-linux-arm64.tar.zst"
      sha256 "6e9a3ce5f64e93312902e39c420ec336255f078a368ca25e99b339d08a6dfa4b"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.24.0/ollama-linux-amd64.tar.zst"
      sha256 "15c5f8d66ba06e0d3b4719df8868612dbd66e14e82760929bb3552e1657cdcdb"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
