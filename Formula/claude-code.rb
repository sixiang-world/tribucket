class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.306"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.306/claude-darwin-arm64.tar.gz"
      sha256 "7d83cdfb0a9457f712881bb2f86b0f8fd655c818dbb8abf679c43fd04de44171"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.306/claude-darwin-x64.tar.gz"
      sha256 "f28e81593425000a1c69db74dc12a5d2272067c8dc2be23857b2c93300eac427"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.306/claude-linux-arm64.tar.gz"
      sha256 "871fd7f46210c13a95a38506e03ac90abfc5125fc25a1d4f840fbab551b5cd2e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.306/claude-linux-x64.tar.gz"
      sha256 "9dc640d16d8228eff9620bde9e0f70d38385a2124f4e7d0a959d0337f0e4b14a"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
