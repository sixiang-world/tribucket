class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.9/ollama-darwin.tgz"
      sha256 "cdfaee591d3ba7753e1bb4ae28be228ef7488199f263b7f202e0eddc900c08f4"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.9/ollama-darwin.tgz"
      sha256 "cdfaee591d3ba7753e1bb4ae28be228ef7488199f263b7f202e0eddc900c08f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.9/ollama-linux-arm64.tar.zst"
      sha256 "2a328795709135fcf0c011b9e2634431ab6f2fcab57ca11264725446cf4894b0"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.9/ollama-linux-amd64.tar.zst"
      sha256 "01f0d0ae50cad3295a79a165033a65cf324f8ae5f7be64679464d29ecf28d67c"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
