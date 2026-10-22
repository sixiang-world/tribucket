class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.8/ollama-darwin.tgz"
      sha256 "29fce20c736f62aa8885b1e83552c5fd8dcc63edc5ffc1b47f2de591a06cde44"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.8/ollama-darwin.tgz"
      sha256 "29fce20c736f62aa8885b1e83552c5fd8dcc63edc5ffc1b47f2de591a06cde44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.8/ollama-linux-arm64.tar.zst"
      sha256 "f2e512f67f86ac5c53847e4e586ca8a9d3f359faf7a71cd69e37f12dcc63ded0"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.8/ollama-linux-amd64.tar.zst"
      sha256 "0bb17cc19e9c1339ddbe0cba55148bf068f8f19dec8ec5fd531461aaa207282a"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
