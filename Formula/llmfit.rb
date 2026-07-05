class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "0.9.38"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.38/llmfit-v0.9.38-aarch64-apple-darwin.tar.gz"
      sha256 "73fc5c2a7edd8aae09a766dca1c0545728c55bd66594b3601527eb7b5cf7f424"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.38/llmfit-v0.9.38-x86_64-apple-darwin.tar.gz"
      sha256 "8f1e7b4f2becafe1ad8507f63ff8880be69a36853a5eb5535aa917d23ffa0220"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.38/llmfit-v0.9.38-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c553f95b3d23661ba14d84bf4078f7945171ba23ee98f2e3465168d5a671a23b"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v0.9.38/llmfit-v0.9.38-x86_64-unknown-linux-musl.tar.gz"
      sha256 "07ecc01590ddc34891ab6e4ac3d62ab702b21e1b47879c439ee0f8073344e930"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
