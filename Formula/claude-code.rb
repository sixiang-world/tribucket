class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.276"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.276/claude-darwin-arm64.tar.gz"
      sha256 "fa258d405e854ed29245190e9fc8d49689a3bcb58c810f97cc6c17774b090c54"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.276/claude-darwin-x64.tar.gz"
      sha256 "d0a65277c7c8d42d483fbcc94daffa816fb37862943bd4d448644c7d19676b8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.276/claude-linux-arm64.tar.gz"
      sha256 "da339bfa5e7345c6a793b4021fd7ac66a98a3f28ec888d106a2dc10ff1ac4e9e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.276/claude-linux-x64.tar.gz"
      sha256 "09514ef3ed18c33c24793c57fa1ecd9b9bb03b75dedb51b08ae5ca9c6588fce4"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
