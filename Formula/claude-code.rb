class ClaudeCode < Formula
  desc "Claude Code — agentic coding tool by Anthropic"
  homepage "https://github.com/anthropics/claude-code"
  version "2.1.156"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.156/claude-darwin-arm64.tar.gz"
      sha256 "c2b9094d4801e906bb615a86360f4fcd69ea3fc1e54e1ba69eefaef64b96678b"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.156/claude-darwin-x64.tar.gz"
      sha256 "062f9ba2a5ec03a059aa3f12c4298f1855133948251efc2c39352f2be42f8638"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.156/claude-linux-arm64.tar.gz"
      sha256 "b4b5a8a4d7a3ee2393febf406e808eec69d16868fadded5016b1c13c87a30767"
    end
    on_intel do
      url "https://github.com/anthropics/claude-code/releases/download/v2.1.156/claude-linux-x64.tar.gz"
      sha256 "5026dd45dadf807400b7fb9d0d9a1831322727bc439e48d778fdcceda003225d"
    end
  end

  def install
    bin.install Dir["claude*"].first => "claude"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version 2>&1", 1)
  end
end
