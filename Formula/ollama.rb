class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.32.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.9/ollama-darwin.tgz"
      sha256 "17a5b096d4515d00a6415012db847a2b353b389ed7ab33d025e3b98c2f05b49c"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.9/ollama-darwin.tgz"
      sha256 "17a5b096d4515d00a6415012db847a2b353b389ed7ab33d025e3b98c2f05b49c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.32.9/ollama-linux-arm64.tar.zst"
      sha256 "79617139521db251c716d6229505d7530171ff4d68e476d0c22dabc15726a237"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.32.9/ollama-linux-amd64.tar.zst"
      sha256 "5d747a43369f61e38f20b5a39fcc5c90647e562cdc61e2e56034f1c5b113d540"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
