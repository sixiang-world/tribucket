class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.33.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.3/ollama-darwin.tgz"
      sha256 "342db03df80bb9db84ff64246031bd5f70c09b59ff52fa5cc9aaae3476cc4a9d"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.3/ollama-darwin.tgz"
      sha256 "342db03df80bb9db84ff64246031bd5f70c09b59ff52fa5cc9aaae3476cc4a9d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.33.3/ollama-linux-arm64.tar.zst"
      sha256 "4425a112af999ae6572c1ce211fbabeaca7bab23ed5860972acdfc0cc2358420"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.33.3/ollama-linux-amd64.tar.zst"
      sha256 "c13cea8f3389db4145f8a6cb88d1747242a48639d7c13e3bda7c1ebdc6eebb2f"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
