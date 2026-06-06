class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.6/ollama-darwin.tgz"
      sha256 "71a227934091757dd24994b4114f0c46039bd2b764537de97a2a0a74b626acc6"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.6/ollama-darwin.tgz"
      sha256 "71a227934091757dd24994b4114f0c46039bd2b764537de97a2a0a74b626acc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.6/ollama-linux-arm64.tar.zst"
      sha256 "71b45e45194cb5f2e8dec74e0c98ef2f2c464d1d422b87ff592a79ceab17cad2"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.6/ollama-linux-amd64.tar.zst"
      sha256 "a6d29b68cb7f74023ad1fbb86330d051ccdd1321a79ea12257b8b9409b095930"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
