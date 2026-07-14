class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.3/llmfit-v1.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "607b3222b347e75035b381e0a1fcbfee2861ddade923d6ea133dcd44b069f3b8"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.3/llmfit-v1.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "d7c559d6e6c66347d867cdd9380042fa5da55cb5c397a22c6b6b79754a4b6bef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.3/llmfit-v1.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2dbcaae16261496444cf87cee7ca7bdd0fa76d3058f3d8bb45311a6a4daea0b1"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.3/llmfit-v1.1.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5889f6947e537619f5e4516156c3adeeb876676a0362453fdc23129ee6785d79"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
