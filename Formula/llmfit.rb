class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.9"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.9/llmfit-v1.1.9-aarch64-apple-darwin.tar.gz"
      sha256 "f2bc332bb07bdbe5c78d8f2cc3dd0c4ec495f17f37cb0df0316ce2de75a4b593"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.9/llmfit-v1.1.9-x86_64-apple-darwin.tar.gz"
      sha256 "a5515d9b535f1aa95c6371d27cf5fc0d54c6be26747988b6135213192bc76291"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.9/llmfit-v1.1.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cef64ec207927d53b81bbf77dcf7ff364591c6f12e02d0f13a3ef4e7de695d50"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.9/llmfit-v1.1.9-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ec88613cc181452545b3594ea3b6243416efbfe429fbd9591ecc7bd466bf7b7c"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
