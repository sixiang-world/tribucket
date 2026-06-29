class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.34"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.34/llmfit-v0.9.34-aarch64-apple-darwin.tar.gz"
      sha256 "2ac70fc2d05f267f08c60532ee485b2deb4906c6faa065fe67cba40eaf613e13"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.34/llmfit-v0.9.34-x86_64-apple-darwin.tar.gz"
      sha256 "752cafd7dbf6ecdd65c560c62c03c42cfd3a0572843e8beeb5d03000aaf0acc8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.34/llmfit-v0.9.34-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e69f3fd93595d412cc35e6e37f95e6048661ad4d842ef074d17c478f068637f9"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.34/llmfit-v0.9.34-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dfa2aed92d5358d24b679fa2e267edc5e8fa983bba7595e706deed5efc845210"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
