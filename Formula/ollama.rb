class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.8/ollama-darwin.tgz"
      sha256 "87694807694a464674d8c671e369612426904da139c1e81cfb06420e383c21b2"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.8/ollama-darwin.tgz"
      sha256 "87694807694a464674d8c671e369612426904da139c1e81cfb06420e383c21b2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.8/ollama-linux-arm64.tar.zst"
      sha256 "f2450dddd55c18689fc922090ca78cbea6015a77eabae7c448608901b6b7c213"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.8/ollama-linux-amd64.tar.zst"
      sha256 "c10b76c39cb72908cc92dff314e80e32736c03f1287efb4b39e0b70fd600cc64"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
