class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.175"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.175/claude-darwin-arm64.tar.gz"
      sha256 "e57a5445e23a5a0c72d5fa08ff3f21c0991e4f5c2de795cf6e145c687916fde9"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.175/claude-darwin-x64.tar.gz"
      sha256 "187c59ef304f979b301cf89181eb1348e28e04cd6a1cbdf1b1780572e9c45cf3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.175/claude-linux-arm64.tar.gz"
      sha256 "b6ba6ca733728e2ca284e715d5ae1baab74410d580da58236787a567009ecf8d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.175/claude-linux-x64.tar.gz"
      sha256 "873ddee228406a44bdf71868046b2c6a1d133379f89805acd48e1107879eef1b"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
