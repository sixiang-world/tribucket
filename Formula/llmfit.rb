class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.11"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.11/llmfit-v1.1.11-aarch64-apple-darwin.tar.gz"
      sha256 "f42249d8af58067dd47ef25f997be24ed2a7c6659499bfd16e7c8c431c6e8baf"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.11/llmfit-v1.1.11-x86_64-apple-darwin.tar.gz"
      sha256 "9c9f56ccf64fee455c5a38b14aa3dd92d95755778e926f986de1c427b6ced136"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.11/llmfit-v1.1.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bb5ea40d26330efce1a884b5b5fc7904f60e55b03d12e5a7fd844a946497b5de"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.11/llmfit-v1.1.11-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ec5e2ac6438ba7bc1d6452a581087f2a6533d504136c1f2a70500b0f558896c5"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
