class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.2/llmfit-v1.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "40ac5fb05ad34dc97c315b4792217b4c85ab5593aeb2bdcdd77ac73e8549b97a"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.2/llmfit-v1.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "44ce0a57c434aab473a4ade9dafdd19ac61d7088186d34084af9cc6e1e6622c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.2/llmfit-v1.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "415c5593fefec820ac4a51fd370bf1d0beb38b79ad42e8ba671faebb1fd10548"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.2/llmfit-v1.1.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0744e742f78739f65aef2589aace2f0b2b5166da02a01dfca8ab3fab665a996a"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
