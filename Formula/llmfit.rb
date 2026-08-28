class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.12"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.12/llmfit-v1.1.12-aarch64-apple-darwin.tar.gz"
      sha256 "8b9878813691adaf95ffab3f167164cccf1f0cac6b92d4a5668024c7523b659a"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.12/llmfit-v1.1.12-x86_64-apple-darwin.tar.gz"
      sha256 "3b6115ea8833c96beba1ddee717bad19c2f77b00469476c584ac3fbfed3750b2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.12/llmfit-v1.1.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2407cfc625aaa4823d4eb994533b15b6f71acda2646b18368a75313462962610"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.12/llmfit-v1.1.12-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a407505890a83bf830c46b5979d4c8240d81a323ec0be7878e6fe79808a1b37a"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
