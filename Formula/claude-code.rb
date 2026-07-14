class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.209"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.209/claude-darwin-arm64.tar.gz"
      sha256 "9ce7e095d3286162c1d89154205c19c9f8c6a06acc88ce094178cd05cff68c3e"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.209/claude-darwin-x64.tar.gz"
      sha256 "d43e70d2b70efd446cd0e8e06296d26d75cdb4eb8c72113c60a2e6a69276b7e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.209/claude-linux-arm64.tar.gz"
      sha256 "df6c182667bf4040855c913e38791691c75fada019c312dcf4fd8873a8d04f0d"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.209/claude-linux-x64.tar.gz"
      sha256 "8a37068aeea24413f59ebab85ab6bfbb67fe0b08f30fc76b77b0672013f539b5"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
