class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.33.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.2/ollama-darwin.tgz"
      sha256 "5751e296a2cd545939bdd51b700de0c20d319f0e723c9d7f48bebb5ab0b731d4"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.2/ollama-darwin.tgz"
      sha256 "5751e296a2cd545939bdd51b700de0c20d319f0e723c9d7f48bebb5ab0b731d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.2/ollama-linux-arm64.tar.zst"
      sha256 "6c648fd62bc8ea18d19aeb0900a03ff2d6a1fc830d901348d070fb93aca4630e"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.2/ollama-linux-amd64.tar.zst"
      sha256 "9785247dea264d9072f09f6c9c0eb4b8e666892826a3d8388eba3e8fb9ed1db9"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
