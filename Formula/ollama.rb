class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.7/ollama-darwin.tgz"
      sha256 "fa3b382e4b90c595e1f473c6df2cd1ecad270c4d04225f6b069e5b86a10f3d33"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.7/ollama-darwin.tgz"
      sha256 "fa3b382e4b90c595e1f473c6df2cd1ecad270c4d04225f6b069e5b86a10f3d33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.7/ollama-linux-arm64.tar.zst"
      sha256 "b4f1fbdbe67f22df7798609a67fcb8283d62292a221cfb55c9c067220deda62e"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.7/ollama-linux-amd64.tar.zst"
      sha256 "88c110a6c9a9130e5ed0aa90f47e8ddb013cb638d834e11ddf1517615704d34c"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
