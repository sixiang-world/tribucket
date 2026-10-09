class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.17"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.17/llmfit-v1.1.17-aarch64-apple-darwin.tar.gz"
      sha256 "294abbb9faa62315acbdb5ee55a2558f327c98df6644922d493d1dde1518a858"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.17/llmfit-v1.1.17-x86_64-apple-darwin.tar.gz"
      sha256 "a859d79292e961e9b9ed21b29bbeb787206c036668a7ec833f23c26e5ef7ca45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.17/llmfit-v1.1.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a43cba391f98132f8696dd73c828fdba3942d62fcdd5daca6dc1ed0621619ea2"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.17/llmfit-v1.1.17-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4cd3c2bde68e5bf79576511ddc70f9e4ee4941c64429b5f57ae94ea93c24e8e2"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
