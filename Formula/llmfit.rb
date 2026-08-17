class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.10"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.10/llmfit-v1.1.10-aarch64-apple-darwin.tar.gz"
      sha256 "1e7db345b6f05caa554a0136a354d3bf773b40265bb8a9833bb8f56ef841136c"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.10/llmfit-v1.1.10-x86_64-apple-darwin.tar.gz"
      sha256 "0a8f3dc77095f52ce9ab999ee09cba3ab83240626236964866cd5abef8db1242"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.10/llmfit-v1.1.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2f180b8809897a63b194553da421ffc568d0e2b098bd08d4834179bb310be67a"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.10/llmfit-v1.1.10-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ef6e2377e9e69cbfed0f810b01813ce001c3ce7f2d8eab0a2ee321134e148faf"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
