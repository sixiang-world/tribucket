class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.3/ollama-darwin.tgz"
      sha256 "14462bd438815eb2c1d4c61224744637131ab744e858a2e2562e7fc7fc2c4f7d"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.3/ollama-darwin.tgz"
      sha256 "14462bd438815eb2c1d4c61224744637131ab744e858a2e2562e7fc7fc2c4f7d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.3/ollama-linux-arm64.tar.zst"
      sha256 "61af0def977ffc9e76cc961f9505d621805653c63f444796de2f77b4eaaa7047"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.3/ollama-linux-amd64.tar.zst"
      sha256 "2597d74fbe654ef6a37db56f771cf37d4a85c6bde4018127874e3927d3113800"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
