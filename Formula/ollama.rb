class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.6/ollama-darwin.tgz"
      sha256 "c256147703b0b24a9871ec9f94fc108f18cf87ff043aebd6f7e4a95fcfb4f042"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.6/ollama-darwin.tgz"
      sha256 "c256147703b0b24a9871ec9f94fc108f18cf87ff043aebd6f7e4a95fcfb4f042"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.6/ollama-linux-arm64.tar.zst"
      sha256 "18fecc359b9366a8462e664d9eccf11e8405e5101fe968ee141689106eea0bd2"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.6/ollama-linux-amd64.tar.zst"
      sha256 "dec2fa50d24e6868ca3c4c977d69d059399372105f951a9acc320a5a79aadcfc"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
