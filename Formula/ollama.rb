class Ollama < Formula
  desc "Get up and running with Llama 3, Mistral, Gemma 2, and other LLMs"
  homepage "https://github.com/ollama/ollama"
  version "0.40.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.13/ollama-darwin.tgz"
      sha256 "bae29252232b9e1358cf5801a7d65a07442af18fb5467cb68c7fc3711f59c511"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.13/ollama-darwin.tgz"
      sha256 "bae29252232b9e1358cf5801a7d65a07442af18fb5467cb68c7fc3711f59c511"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ollama/ollama/releases/download/v0.40.13/ollama-linux-arm64.tar.zst"
      sha256 "913d9a28da6da86d551ce4ca531457767bb14d511cbc1d5ca93e9b3b8b9a8666"
    end
    on_intel do
      url "https://github.com/ollama/ollama/releases/download/v0.40.13/ollama-linux-amd64.tar.zst"
      sha256 "c9490e0f520be21271d969e6703f012268b1d39f8b70dd58854e5bfef7a75bb6"
    end
  end

  def install
    bin.install Dir["ollama*"].first => "ollama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ollama --version 2>&1", 1)
  end
end
