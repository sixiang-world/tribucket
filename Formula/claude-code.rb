class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.186"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.186/claude-darwin-arm64.tar.gz"
      sha256 "8f87d5ce142b729a62e23ee18ad5645b3836c5e72f2fb249acf228f1e0611342"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.186/claude-darwin-x64.tar.gz"
      sha256 "073a36742e716169fb185eb65b8719e3714b6788aff757476d9b73866adf4a72"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.186/claude-linux-arm64.tar.gz"
      sha256 "74c099dc935ff69ea0e31be067766945de8abc76444dd170772a7f3ba52329c9"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.186/claude-linux-x64.tar.gz"
      sha256 "2df436ea6486ec8dee5316ec8fad6f922d3aee24bfcb15c8fa663864b6338698"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
