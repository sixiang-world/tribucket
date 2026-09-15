class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.273"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.273/claude-darwin-arm64.tar.gz"
      sha256 "ae48db6a5ea2bdec38bf8996dd2ae041d801de26dc3d210aba86d2156b485ce4"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.273/claude-darwin-x64.tar.gz"
      sha256 "0ca37d2f32674a980d1f91d7315be9ae67e044134579e24968d8d94a3de75d73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.273/claude-linux-arm64.tar.gz"
      sha256 "33983f2ec19610aaf9fe6d255fb61d91e985d2e4f76c70387da4820c8f8cf89e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.273/claude-linux-x64.tar.gz"
      sha256 "afd5dbac0b1dfeb8f9fb8fa8adaaf8ba49c7a334fda73b9f49ed2e99197ee829"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
