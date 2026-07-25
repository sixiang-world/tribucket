class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.4/ollama-darwin.tgz"
      sha256 "15383493225d5e7e7fda052dc103ab4d2835a22eabb41655f1d6302c6d1577bc"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.4/ollama-darwin.tgz"
      sha256 "15383493225d5e7e7fda052dc103ab4d2835a22eabb41655f1d6302c6d1577bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.4/ollama-linux-arm64.tar.zst"
      sha256 "a170d6e1cce330b26b7e6a1ff4e75357afe402a342eb73ab80e79c16d7db6868"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.4/ollama-linux-amd64.tar.zst"
      sha256 "c00efcc236e87168e55cad9ca7c57817762dad04ccfc4565546935facf22e359"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
