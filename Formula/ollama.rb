class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.3/ollama-darwin.tgz"
      sha256 "30808c989707408b0c34eebc46d6552b6071031a5b3b2c7848cb6096f00698e1"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.3/ollama-darwin.tgz"
      sha256 "30808c989707408b0c34eebc46d6552b6071031a5b3b2c7848cb6096f00698e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.3/ollama-linux-arm64.tar.zst"
      sha256 "e849f4ad22d44ffbf4b48032c999bfae9c8a5b31a3f8117c03a77120e50e9470"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.3/ollama-linux-amd64.tar.zst"
      sha256 "e8377c6aaf727d45907b847c3e7a6bcde0d34554b158ce2327b008dfc34e1c8f"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
