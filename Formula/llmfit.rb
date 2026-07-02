class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.35"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.35/llmfit-v0.9.35-aarch64-apple-darwin.tar.gz"
      sha256 "bfaa8198eb3ebb99c43865dfab708de191f176f07198b65a73746e0a84c55a81"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.35/llmfit-v0.9.35-x86_64-apple-darwin.tar.gz"
      sha256 "c542afbd243015e75bec28b9899eab42e9f3f6bb2b2be913711726913e00b9ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.35/llmfit-v0.9.35-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3ce6bc262916dc6e9b3e0f32260bda795a7d977f711580ac87c19ff81011a53b"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.35/llmfit-v0.9.35-x86_64-unknown-linux-musl.tar.gz"
      sha256 "98d05510b9d7c7294c130638a160353ed6c5e674e89194d26e363c6216638b9a"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
