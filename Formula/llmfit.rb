class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.18"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.18/llmfit-v1.1.18-aarch64-apple-darwin.tar.gz"
      sha256 "68884975b75e93aa727648dd116596417fddecd47f48c469548391761508075b"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.18/llmfit-v1.1.18-x86_64-apple-darwin.tar.gz"
      sha256 "3f7298912f12aecfceec861a60d9c4273dcddaccb74d207d17c2572ea3182a87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.18/llmfit-v1.1.18-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cfaab4e67202808adaf237493171589d6a81b4d31049078d5046598acefef9fb"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.18/llmfit-v1.1.18-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ac9ec1611c64d0098abe8f29dc0e23df2e895ed84700d0611d62ad90ffb72926"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
