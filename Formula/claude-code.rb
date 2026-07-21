class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.216"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.216/claude-darwin-arm64.tar.gz"
      sha256 "97393451bfbf9714f9e19a33ab274f7ac607de8cb3f0743b822725847fd50a56"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.216/claude-darwin-x64.tar.gz"
      sha256 "35ab06eb31bdd3d8b1d28adff2de7568232e4421ce48666256ab44e27aaa336f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.216/claude-linux-arm64.tar.gz"
      sha256 "0b35e5c4a9e633a5591c2af8e9fe452f90a44efa211af7a6036312e8343ecb96"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.216/claude-linux-x64.tar.gz"
      sha256 "507aaa980a7867b8b675e998cc8e6a39b49cf488503bb192d2e7554263e5f945"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
