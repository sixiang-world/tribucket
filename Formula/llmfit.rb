class Llmfit < Formula
  desc "LLM fitness evaluation tool"
  homepage "https://github.com/AlexsJones/llmfit"
  version "1.1.7"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.7/llmfit-v1.1.7-aarch64-apple-darwin.tar.gz"
      sha256 "4f8db9a891e3d81237c85367edb3e8afcc44eb98dd69fa7d344e943b40346c47"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.7/llmfit-v1.1.7-x86_64-apple-darwin.tar.gz"
      sha256 "c47d353119be0a1cf17fb4e7a64195db35628d6ee72d5fd550a3de2c41300e9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.7/llmfit-v1.1.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "94b898051555f8aea1a1cd5a38ad7aa067c707fae614d2e498f4ae6cf8ad2dbd"
    end
    on_intel do
      url "https://github.com/AlexsJones/llmfit/releases/download/v1.1.7/llmfit-v1.1.7-x86_64-unknown-linux-musl.tar.gz"
      sha256 "44ed6fda120d8961f90917faddcc6482d9c670aa3a96337390f6f5752ef44c4d"
    end
  end

  def install
    bin.install Dir["llmfit*"].first => "llmfit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version 2>&1", 1)
  end
end
