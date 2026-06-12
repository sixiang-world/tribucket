class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.8/ollama-darwin.tgz"
      sha256 "52acbca4e89c53db9abc586a22b5633fd101db293177264b9a0fe5d64a42a064"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.8/ollama-darwin.tgz"
      sha256 "52acbca4e89c53db9abc586a22b5633fd101db293177264b9a0fe5d64a42a064"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.8/ollama-linux-arm64.tar.zst"
      sha256 "668a6f934b0b0455128bb4a76c9e50b9e5f274f9dc7710a066b7073e5bd36588"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.8/ollama-linux-amd64.tar.zst"
      sha256 "ffe2b2c2f2f5f5b30c081ec353c2e0bb2d9ead516064a8e22663b24b8fd8dca0"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
