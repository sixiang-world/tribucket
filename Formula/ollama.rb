class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.0/ollama-darwin.tgz"
      sha256 "9f95b794325857d412c1a795db78fbb35aee3567a0b81868917606cdb2d693cb"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.0/ollama-darwin.tgz"
      sha256 "9f95b794325857d412c1a795db78fbb35aee3567a0b81868917606cdb2d693cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.0/ollama-linux-arm64.tar.zst"
      sha256 "9921a37f3e9319d5d12744e40f112b57f50a8f9d2256a8765042e6b45486d1f5"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.0/ollama-linux-amd64.tar.zst"
      sha256 "460e9b0789bedb0b6343fa7b9cccf15e5cb4de10b762f21c920cccf00a2f2968"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
