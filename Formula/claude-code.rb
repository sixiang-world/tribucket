class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.250"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.250/claude-darwin-arm64.tar.gz"
      sha256 "389a3678c85b4b45d06709bc563bc0c72ce37cecdfb2c691cb659f227ede465d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.250/claude-darwin-x64.tar.gz"
      sha256 "846e061e47482d8482550f10bd1ec4c3e3632926d9832882ebc3a979eaa39841"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.250/claude-linux-arm64.tar.gz"
      sha256 "3707880f19eeb575d0a4002b6f136c2e4c827d5a8867c468a3da28977b02591e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.250/claude-linux-x64.tar.gz"
      sha256 "c1951ff3879db3a1359cbec244357642814eb679ec683fe6dab0f9fba1c04ab2"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
