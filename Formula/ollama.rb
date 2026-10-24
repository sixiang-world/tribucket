class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.10/ollama-darwin.tgz"
      sha256 "ac4f4d012a6d156718eef9aa8f2c7dd7e1f5c47362faf84d3eed412d805f2e2b"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.10/ollama-darwin.tgz"
      sha256 "ac4f4d012a6d156718eef9aa8f2c7dd7e1f5c47362faf84d3eed412d805f2e2b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.10/ollama-linux-arm64.tar.zst"
      sha256 "57dca26f51efc050112b733a65dea6f6c8e68da7a2946afd7c1eb8834d9eeb92"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.10/ollama-linux-amd64.tar.zst"
      sha256 "1e8ad2d2a394efdd235bee74deec237badd95142ffba77588140ab2a9ecec227"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
