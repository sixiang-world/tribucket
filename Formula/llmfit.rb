class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.8"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.8/llmfit-v1.1.8-aarch64-apple-darwin.tar.gz"
      sha256 "54927befb6522c78e523e325fda4233ebe22d9d16eebf100ec972b3de632804a"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.8/llmfit-v1.1.8-x86_64-apple-darwin.tar.gz"
      sha256 "e30e4065c95f83a1d1dc2cdd210521edd3ad5afe15b9d05a949bfd29de3c7c38"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.8/llmfit-v1.1.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "53844a39b025139458bf5546066c7857b79214d65babe3a90b9ccb832c2d14e5"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.8/llmfit-v1.1.8-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ff2b5d0f5ce4afcb20e02996cb7f66789935f96af756e4d2847c89eb11ba4d8c"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
