class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.199"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.199/claude-darwin-arm64.tar.gz"
      sha256 "30b628e9623d824e37fc3368ed02c93637a524d97031eae0373857013290e8ac"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.199/claude-darwin-x64.tar.gz"
      sha256 "28633041a069cc5f3f7513c85d4c979aff03e8cc9098e4558a83d921531b4890"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.199/claude-linux-arm64.tar.gz"
      sha256 "fb4a6ee96fb79b9c2447df52e47142691a696d9748d4a423d3b594fc0dff751a"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.199/claude-linux-x64.tar.gz"
      sha256 "80a65363a6735143f9bbd7b7c44af604ccd356c78bf4ded12491e66f2bfe7402"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
