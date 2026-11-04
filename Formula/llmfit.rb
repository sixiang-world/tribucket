class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.20"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.20/llmfit-v1.1.20-aarch64-apple-darwin.tar.gz"
      sha256 "d95629660505debdd3d8086a020512600ae1e1fcc35d89dc716424788497a73b"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.20/llmfit-v1.1.20-x86_64-apple-darwin.tar.gz"
      sha256 "3fcce436bb6d34d5fd4e3e62ccd7232b8332ec3b91f8c47ec8a346df90cbde66"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.20/llmfit-v1.1.20-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fe56463b13757663eb936559424667693bc7b9e33df1ac1572064fd8685ed98d"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.20/llmfit-v1.1.20-x86_64-unknown-linux-musl.tar.gz"
      sha256 "64d71c876965fb883c175ff20558a26f4dd5ad1404b582a1922c496b16720421"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
