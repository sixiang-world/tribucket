class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.284"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.284/claude-darwin-arm64.tar.gz"
      sha256 "75603fec942fff2cbda25cfec94801402d029b4a7827b9875f64a7a326f46451"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.284/claude-darwin-x64.tar.gz"
      sha256 "c0941fd6902dd6c7c9d2da7d71778e65bc9718aa496c1460e5b9b434a4651392"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.284/claude-linux-arm64.tar.gz"
      sha256 "671804ae4f461cf9508b39d676046724ec9fef0bf602e4f77471825d77eec2c7"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.284/claude-linux-x64.tar.gz"
      sha256 "3e143fd5753fda1d150dd081ff7c584d0eb5b85cc259729e5429957ed9de202e"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
