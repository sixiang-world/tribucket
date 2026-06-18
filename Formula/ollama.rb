class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.10/ollama-darwin.tgz"
      sha256 "ad8a4d2918ed09480b8160419570602b4f49e48c9e3792efb601c0f54619e48e"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.10/ollama-darwin.tgz"
      sha256 "ad8a4d2918ed09480b8160419570602b4f49e48c9e3792efb601c0f54619e48e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.10/ollama-linux-arm64.tar.zst"
      sha256 "b626aef722ddb9d64dd20a76eeba9267abc5e9494faabb97839db85462b707d7"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.10/ollama-linux-amd64.tar.zst"
      sha256 "046d8f28e58d58477a49558d8d1bcb2e81ca8b287f93c44b12ff919c10d178dd"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
