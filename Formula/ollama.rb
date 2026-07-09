class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.31.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.31.2/ollama-darwin.tgz"
      sha256 "d72381baa260f6ce014c8e942e605eac76cac5313fcb3401eaf5495f659cfd6d"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.31.2/ollama-darwin.tgz"
      sha256 "d72381baa260f6ce014c8e942e605eac76cac5313fcb3401eaf5495f659cfd6d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.31.2/ollama-linux-arm64.tar.zst"
      sha256 "07a0adfcf3ed48ff110e2a3bcec897ca4d3f77d6f817d6ff63e83debfd102a31"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.31.2/ollama-linux-amd64.tar.zst"
      sha256 "2c88f0f31a959bac5a3cad4cc5296ec568551d4aa79f548f554adb2b575b3133"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
