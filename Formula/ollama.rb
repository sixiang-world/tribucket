class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.34.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.4/ollama-darwin.tgz"
      sha256 "e9c8fddaab5f48f47f2c4ae3d23d0732f5182417125353faeed2188e34a22799"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.4/ollama-darwin.tgz"
      sha256 "e9c8fddaab5f48f47f2c4ae3d23d0732f5182417125353faeed2188e34a22799"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.4/ollama-linux-arm64.tar.zst"
      sha256 "96f50a1192133028cf4e010d8c333f8af14b1505db6be7b2034c11487e7fd7e6"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.4/ollama-linux-amd64.tar.zst"
      sha256 "c238986e61d40c0cc5f4a9b9e40b9eea104350b77efa34741fc134e105cb9533"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
