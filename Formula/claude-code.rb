class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.290"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.290/claude-darwin-arm64.tar.gz"
      sha256 "f5315ca0b8d87d89022e0f4e53c30c8be3ab9ad7373154ef56313deadc63d6bc"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.290/claude-darwin-x64.tar.gz"
      sha256 "fe19da493859f1800131a62afb3c7925b45b67fe996f536ecd7941b88f1129c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.290/claude-linux-arm64.tar.gz"
      sha256 "f35e48a99fbbbd63f671d5308341831111d66231acb3253b772c7dfd11455608"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.290/claude-linux-x64.tar.gz"
      sha256 "8da960e58d5d064524932f3ef58bdc1b1ff6203f2449941d189e351110b0355b"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
