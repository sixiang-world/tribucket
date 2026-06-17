class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.30.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.9/ollama-darwin.tgz"
      sha256 "d32750cf107046251aeaf18dfaff42a0319cddda821d502afba18bacce8b166f"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.9/ollama-darwin.tgz"
      sha256 "d32750cf107046251aeaf18dfaff42a0319cddda821d502afba18bacce8b166f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.30.9/ollama-linux-arm64.tar.zst"
      sha256 "674f70581e569b66f42b53fbdf9c0482276b579bc93b1d254a08c45f5d9f270a"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.30.9/ollama-linux-amd64.tar.zst"
      sha256 "670557d57f300b8ff98eb3b537e5bda69d4532594e180da7dc61358c614e3619"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
