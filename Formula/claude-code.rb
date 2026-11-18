class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.327"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.327/claude-darwin-arm64.tar.gz"
      sha256 "e61d78415072c4f762ec2254236087476764f6b266611a33ef8c66c0a03fbec0"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.327/claude-darwin-x64.tar.gz"
      sha256 "82248550d146959485d09ab882917c9bdb75389eaad46e986978c977d8097f98"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.327/claude-linux-arm64.tar.gz"
      sha256 "39d249137bacdd872d536d2aa50fd52bedd5d55c79e35efce96b9f658b2ea6d8"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.327/claude-linux-x64.tar.gz"
      sha256 "7f03a9981918fbd38eca529bdd19807eedb021a9ed2feb9923dc10a581a5aa1f"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
