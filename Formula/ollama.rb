class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.0/ollama-darwin.tgz"
      sha256 "b490b4925a95c5f3dfcd889e566cf3dcd727848d59057fb00b03f1d6630326dc"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.0/ollama-darwin.tgz"
      sha256 "b490b4925a95c5f3dfcd889e566cf3dcd727848d59057fb00b03f1d6630326dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.0/ollama-linux-arm64.tar.zst"
      sha256 "4d27cb1d8f46176a3c0ce10aea2a16e4ad73dfe1599f2ed13468f29e5b8aba0d"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.0/ollama-linux-amd64.tar.zst"
      sha256 "c94aa4156b3d13e64ebc2efe5ea53f015384c882be776e6695cfb37fb180d5ad"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
