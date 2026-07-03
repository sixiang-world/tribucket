class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.200"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.200/claude-darwin-arm64.tar.gz"
      sha256 "8196deb57d96ad615d32cdb1e637f9c5aa3d33b21f599eb9e3ce6bc51f88c221"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.200/claude-darwin-x64.tar.gz"
      sha256 "0a4bb54959606e3479654ff6a38068b9bc26dc1cae69aae9199421bbfefe72b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.200/claude-linux-arm64.tar.gz"
      sha256 "e96284cd8ec8822ca6038c95b9d86fa70499a203755852aa5c4e1129d3dadbf3"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.200/claude-linux-x64.tar.gz"
      sha256 "29da0cb348acaf1a1486dfa12935b1390adecbe16c54449f9d0e9c608259732a"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
