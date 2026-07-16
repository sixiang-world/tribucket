class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.1/ollama-darwin.tgz"
      sha256 "346d28fe70f3ef3776e42100f5721510aa35fc07f3733f6629dbb117b1cfede9"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.1/ollama-darwin.tgz"
      sha256 "346d28fe70f3ef3776e42100f5721510aa35fc07f3733f6629dbb117b1cfede9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.1/ollama-linux-arm64.tar.zst"
      sha256 "20fb8d14694f73b97dc41519e27ef06166236207e7efe793f1698a43722215f2"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.1/ollama-linux-amd64.tar.zst"
      sha256 "83b1f22841eb7f6c4900c6797f960ebaa09466874442ea5b8ae3da6980d3914c"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
