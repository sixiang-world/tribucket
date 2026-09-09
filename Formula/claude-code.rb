class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.267"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.267/claude-darwin-arm64.tar.gz"
      sha256 "eef3ff022932943bffca2439f8ca4a28381b2adc1cf46c76177879e233c1b290"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.267/claude-darwin-x64.tar.gz"
      sha256 "2b1d62b17ac11bedc9b70dfdbdaa36b9bcb979be93a64a9fb6c8b9d11b6ffa63"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.267/claude-linux-arm64.tar.gz"
      sha256 "a8d72d6586f7858210c1fcd538c4a517d9cd44268d92edbc71380f56afab372f"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.267/claude-linux-x64.tar.gz"
      sha256 "449bc65dc82d68694103a801c8ac54b6549f9e12f469217c9e0d5560c1085023"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
