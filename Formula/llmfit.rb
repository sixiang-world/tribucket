class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.37"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.37/llmfit-v0.9.37-aarch64-apple-darwin.tar.gz"
      sha256 "0eae54fb5a995235a799926d0032180659efa34e07fd4d66856f321d95b4d4c6"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.37/llmfit-v0.9.37-x86_64-apple-darwin.tar.gz"
      sha256 "0b7c060a75aae6d18eb6f1a5677e87d8b72ce33f0331bdebafc5f5a7c2edec6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.37/llmfit-v0.9.37-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "433b6505b80e4279f55f7ed71c07cafa75454bab4a05ee1a5b66d15f7a004bcf"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.37/llmfit-v0.9.37-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bccfdc1844000987b34659eecec49f84f021f5acd317938f08ca4f182cac1bfe"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
