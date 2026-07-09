class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.0.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.0.1/llmfit-v1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "e6a684a6e4cc8b3ceca72e0f51be7bb29fca53578b95ecfda7b8b2587383235c"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.0.1/llmfit-v1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "00466ccdf94f8cb085c5ba58f9539c83989af24891bcd99ef45b3cff45f8c2ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.0.1/llmfit-v1.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2c979569f0dac90924e9288d79639cd91329d6ffa7a6319bb09f8b144bc75bed"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.0.1/llmfit-v1.0.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d0862d688e2fe79ed6f43604d608565dd4bf26a1065241369675dba0dd19af00"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
