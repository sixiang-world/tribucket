class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.2/ollama-darwin.tgz"
      sha256 "eb2f2ea03d91d01d550736a49b54eb619056e9f334ff70b3ba698cf0a50ee2e4"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.2/ollama-darwin.tgz"
      sha256 "eb2f2ea03d91d01d550736a49b54eb619056e9f334ff70b3ba698cf0a50ee2e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.2/ollama-linux-arm64.tar.zst"
      sha256 "2acbaf1fd89d698a94be8515dd20a372a94907a6ca27a3312bd74741752291db"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.2/ollama-linux-amd64.tar.zst"
      sha256 "713fecf63c9091b4de3ff49a846206a59c84e6d71eb8702a6776c1db4a6ee8ea"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
