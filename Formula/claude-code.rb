class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.233"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.233/claude-darwin-arm64.tar.gz"
      sha256 "5dce92ccd93173fead018f2a8262189da88c7d6fffbaa666b7a81a6b05f72afe"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.233/claude-darwin-x64.tar.gz"
      sha256 "84a820ad17e08eaef497dfd8cd282b86b7a59dbedd18f2780aa7e82ef8b9373a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.233/claude-linux-arm64.tar.gz"
      sha256 "b5ca70610eadee40a82c6fa74f5f873eb70d5fde94bdc67df1c51416eb45e72b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.233/claude-linux-x64.tar.gz"
      sha256 "23eec49e0453a3a7b9d933228cb09639fc0bcd962039258d8e4cde72fa5b8741"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
