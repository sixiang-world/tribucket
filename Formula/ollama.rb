class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.13/ollama-darwin.tgz"
      sha256 "71efd44f3b5f2019f42bae17ae58eb3de8bd25ce3ca3bc89aea58e53e5d091d1"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.13/ollama-darwin.tgz"
      sha256 "71efd44f3b5f2019f42bae17ae58eb3de8bd25ce3ca3bc89aea58e53e5d091d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.13/ollama-linux-arm64.tar.zst"
      sha256 "ce2ebf080a5fee73ffd51bdf4684ccb5d44b3ee5bd4ac6fa80155595b26bb910"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.13/ollama-linux-amd64.tar.zst"
      sha256 "0fd1dece38a1c6242e8013ce20b597345c5de072ae6b320160edb0e729ef1de1"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
