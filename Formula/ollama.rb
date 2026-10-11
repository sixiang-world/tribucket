class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.3/ollama-darwin.tgz"
      sha256 "a2d1d906a2c8febd9cb18f5c183854d0a6db5dc522940d68b0c0ed048e8dfdea"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.3/ollama-darwin.tgz"
      sha256 "a2d1d906a2c8febd9cb18f5c183854d0a6db5dc522940d68b0c0ed048e8dfdea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.3/ollama-linux-arm64.tar.zst"
      sha256 "5754700747a93ea14db88888f08072386d2da6fbf7dd75be19a684348b9f28b8"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.3/ollama-linux-amd64.tar.zst"
      sha256 "ce6f8b671a699bf1ebafb28d60dbbabf4f37b30b499145fa308a8ba72de021d6"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
