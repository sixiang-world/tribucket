class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.211"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.211/claude-darwin-arm64.tar.gz"
      sha256 "f897f9ddf5fbda29b6cbcc3c987ba05b63ee8bf5da82f2fd5d6a9d8e8c00a3ab"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.211/claude-darwin-x64.tar.gz"
      sha256 "d17b5cc80dc9500e375442b9817a09c12b74fc0dee8ad5323ad4a209b3a0e4e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.211/claude-linux-arm64.tar.gz"
      sha256 "7db1b0c4a08d6252643118ea6ee0f80480a2bca2420f0190b2f226d984c0239a"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.211/claude-linux-x64.tar.gz"
      sha256 "aa0476621195c8fe9ed0ec7a8220a2f409476e7b2c2c7a6079c7c8f62c80f245"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
