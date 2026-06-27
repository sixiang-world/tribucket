class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.11/ollama-darwin.tgz"
      sha256 "4620272018aa974fb146741e51fa69dbecd141922143354d4643a45381faf2e6"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.11/ollama-darwin.tgz"
      sha256 "4620272018aa974fb146741e51fa69dbecd141922143354d4643a45381faf2e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.11/ollama-linux-arm64.tar.zst"
      sha256 "7779570efb5c9ad71f67796e7f850bba1afdf634f8fe2d15bcaa64ec8caca5c5"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.11/ollama-linux-amd64.tar.zst"
      sha256 "11dc89b6c68f136f85ef10e00957530ffab61c35f227696dbf8a11169b47f165"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
