class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.4/llmfit-v1.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "6efef2fe91b67830f50f6a601d28c9bf5cd3f4bf9d0635d38889f95b287af7ab"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.4/llmfit-v1.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "c4991576184dd293a31d3d9dee14e5e0956328feefe12fd8667d36e13073f2cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.4/llmfit-v1.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "51a7708c7ca4c5c47ad7657c7f1afac89bd84b31aab53b947f5baab60a3216b3"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.4/llmfit-v1.1.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7573762da09e883e5141b4ebf4ddedc2ae34f156963ea011fe7af784184f8b1d"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
