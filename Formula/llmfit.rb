class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.15"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.15/llmfit-v1.1.15-aarch64-apple-darwin.tar.gz"
      sha256 "6207b32a3fa97778a21afed7bbf5f33c569bda35202e04a27b4989880687e6d7"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.15/llmfit-v1.1.15-x86_64-apple-darwin.tar.gz"
      sha256 "aadb97d706d3b03fb2c4573b0cfb8f421943023beb6617fea1229b033dfc6d4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.15/llmfit-v1.1.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c68d8720bf86ae8894790c2e16bfe942e8bc1983ecc73958e86bdefab94e69f8"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.15/llmfit-v1.1.15-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4ba3519adf8f861af548554272193ad1ae45bd7e72db3879456b2e76d65a6100"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
