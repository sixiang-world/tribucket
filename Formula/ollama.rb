class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.16/ollama-darwin.tgz"
      sha256 "a743717494315da7cd352982b805f6b992d4b4452ca117fd5fbf86c4ee46fca0"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.16/ollama-darwin.tgz"
      sha256 "a743717494315da7cd352982b805f6b992d4b4452ca117fd5fbf86c4ee46fca0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.16/ollama-linux-arm64.tar.zst"
      sha256 "e45b8e6dcb86cb9f3057396351655079c9a4879b4ced2678c9350d375dcbc224"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.16/ollama-linux-amd64.tar.zst"
      sha256 "87bfafb2acbc89b2e6a1be0a9043de6aa75fb450696f86bc426e65fc448f788d"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
