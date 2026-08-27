class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.247"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.247/claude-darwin-arm64.tar.gz"
      sha256 "77709dc499a57c3106831162fed02f7c520897bb061cfd1b4d06110f8ab871ce"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.247/claude-darwin-x64.tar.gz"
      sha256 "b51cf8ffdde4bd3f9ab3a4b9b1f1176ca3120c66a7a5fbccce6e5c88f0d9a049"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.247/claude-linux-arm64.tar.gz"
      sha256 "4ef57315cff1d3cbfb2ef5e28f9e8560bafc76149b6798c227ec431f2e9018ad"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.247/claude-linux-x64.tar.gz"
      sha256 "148632dc7eb82cc79e634e8decaa041f586f018d6e6e23648231986798737b15"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
