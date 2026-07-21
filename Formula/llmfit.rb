class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.6"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.6/llmfit-v1.1.6-aarch64-apple-darwin.tar.gz"
      sha256 "8c3e3a239df717221da9102cdb62e02519d4f95af58d1a45c380c6aa917c3faf"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.6/llmfit-v1.1.6-x86_64-apple-darwin.tar.gz"
      sha256 "096720e6b611d3f4ced61b75f8ceb3eae3dd6b46965f2bc07ac6237fdf480eeb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.6/llmfit-v1.1.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f1a2c47a8907f2c4312bdb9ae2b26ffb2ffff8d4521c1c58ef2fbe53af328346"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.6/llmfit-v1.1.6-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1e09232a128455596a2d348ab5893741d04b94aa6d924f1253462dc13304f7c6"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
