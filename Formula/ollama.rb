class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.34.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.2/ollama-darwin.tgz"
      sha256 "f33b2a5aa59bc6c961ed3ec23ba9dc646ca6d99ced8d2a0d46eb3a522167dd3f"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.2/ollama-darwin.tgz"
      sha256 "f33b2a5aa59bc6c961ed3ec23ba9dc646ca6d99ced8d2a0d46eb3a522167dd3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.34.2/ollama-linux-arm64.tar.zst"
      sha256 "8edcfe99eb7546d9422cfa8297d341dcd50e090e192ce1a8092a6ab6d182867b"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.34.2/ollama-linux-amd64.tar.zst"
      sha256 "e155b83589986d2c581fdbf1381ea3ebdb16549883679cd5a0627f7cdc05b12b"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
