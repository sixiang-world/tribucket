class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.16"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.16/llmfit-v1.1.16-aarch64-apple-darwin.tar.gz"
      sha256 "e5a558de2af332aa2a75547086c8983fc2f43c7c9a966fcc20d9ce4108ec6886"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.16/llmfit-v1.1.16-x86_64-apple-darwin.tar.gz"
      sha256 "1face5fa683c84b65ecde3c9ba7cb8eb895ec31f0819a3d29861e33312467627"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.16/llmfit-v1.1.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87d1fd489cd90d4e28e4421bd9a9411d89d4f1ee2526216db0207df4ba7152ff"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.16/llmfit-v1.1.16-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9c974f97ac72371d61044eb22ddabff27e9393f681f1c141dbe467699fe3bc48"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
