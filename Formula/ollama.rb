class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.35.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.35.1/ollama-darwin.tgz"
      sha256 "3137dbf28948ee844e0fb3e584d9b5de6879d73d9f0cb7eff3ad64930601d307"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.35.1/ollama-darwin.tgz"
      sha256 "3137dbf28948ee844e0fb3e584d9b5de6879d73d9f0cb7eff3ad64930601d307"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.35.1/ollama-linux-arm64.tar.zst"
      sha256 "b1b1c85d25136b256d3740f6ecd2f7c0105e8ca71642fd6ff2fc199f3cefd69d"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.35.1/ollama-linux-amd64.tar.zst"
      sha256 "9fcd79ac4575b2bd31b992eee18b1000c8ad126b451627c8f8cd091714cfbb10"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
