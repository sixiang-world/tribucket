class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.31"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.31/llmfit-v0.9.31-aarch64-apple-darwin.tar.gz"
      sha256 "36e27d803fb740782dd6a64c7511e09f93864fe1cc5ecf986b9df850bb32dd69"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.31/llmfit-v0.9.31-x86_64-apple-darwin.tar.gz"
      sha256 "bb52fe6e344cb265e0de20e24372c1dbfd8a1c75020a0d8c638df614263143ec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.31/llmfit-v0.9.31-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5bb63ebfa576fabbf59dce765d7367ccf4fcfe2ad8ad2a21d60a3151fa5bfb1d"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.31/llmfit-v0.9.31-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6faee7b2358e1f5dad1df565ec518e356f7879fe90be6ca715b1ac4506acc2fc"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
