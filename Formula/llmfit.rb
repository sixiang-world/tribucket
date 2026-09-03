class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.14"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.14/llmfit-v1.1.14-aarch64-apple-darwin.tar.gz"
      sha256 "eec735a5137936269c4b166a08c30ee7827eacd2111d7ef8bb9d12b0c510af53"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.14/llmfit-v1.1.14-x86_64-apple-darwin.tar.gz"
      sha256 "9c780a3778f6980bda7cd85d018c3841be4361b9a4262fb27c689b9117c16ec7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.14/llmfit-v1.1.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e610fece17d2af0bae3ba59dd3def04f4ef7bf96ad4bf5f4042bd74de87dddd1"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.14/llmfit-v1.1.14-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3b6e43756f2cee2e7806f70fb1e9ca650446784dcda91d75b5ce953b406b95c5"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
