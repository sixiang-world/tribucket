class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.14/ollama-darwin.tgz"
      sha256 "f3bf9a528e908da0da5a2b3a4ad3252a369d62186501dc4880261e8d9023bff5"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.14/ollama-darwin.tgz"
      sha256 "f3bf9a528e908da0da5a2b3a4ad3252a369d62186501dc4880261e8d9023bff5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.14/ollama-linux-arm64.tar.zst"
      sha256 "39bb333b7b4c0bafcdd7fad35eab1ae9aaf4518ea0f2c731de4376e3a29c94d0"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.14/ollama-linux-amd64.tar.zst"
      sha256 "993e83d08c3d13d17c55009a3e2664c8a25445e644aec3a68bef5abb6abce67d"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
