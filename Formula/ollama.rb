class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.4/ollama-darwin.tgz"
      sha256 "a4ceae4b2aaf18df37ebcbfb56ba3a37a87838631112d66c2be07268693c8d58"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.4/ollama-darwin.tgz"
      sha256 "a4ceae4b2aaf18df37ebcbfb56ba3a37a87838631112d66c2be07268693c8d58"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.4/ollama-linux-arm64.tar.zst"
      sha256 "1a314ac530d2c23bf6d2aaaf4a4aba8cc0b2a4ee8bc8fae3f3aa88bff7f7177b"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.4/ollama-linux-amd64.tar.zst"
      sha256 "15f31e9576d15a481e099b4145dba6e9f8c1f295927d6b8895300ae30ed3740a"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
