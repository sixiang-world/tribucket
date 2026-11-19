class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.328"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.328/claude-darwin-arm64.tar.gz"
      sha256 "04f981829d2749bac30a4fee1e533e2c8f826071926703d351fc1a30807b2655"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.328/claude-darwin-x64.tar.gz"
      sha256 "620b53b98de2ddf4d96311b2e575fb529b202de88c8666e87db20ba945f80f76"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.328/claude-linux-arm64.tar.gz"
      sha256 "e95be009ef9548aec0bd34fe2d2736e9b887aef7452b31a8cd3d00cfe0ed7382"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.328/claude-linux-x64.tar.gz"
      sha256 "4404b3dc35afe7dde16c572197f69c210dffdb038f05ee3c532e683732f5aa9f"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
