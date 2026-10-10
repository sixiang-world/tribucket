class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.50.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.50.0/app-aarch64-apple-darwin.zip"
      sha256 "b7de40f9c4a29b1c6e26619b776d02b432902550de9a79e4a71a416e86cc41f5"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.50.0/app-x86_64-apple-darwin.zip"
      sha256 "b057d51bc3b0fa55c71c40774cdef687656e57b630a891c1a7d4e96e57b27d35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.50.0/app-aarch64-unknown-linux-gnu.zip"
      sha256 "3a4ad22dd1dca7a4900a173de65885578617af57fa13dd93b8d345d6b352770e"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.50.0/app-x86_64-unknown-linux-gnu.zip"
      sha256 "0fd3f489639abb8465a914b74b8779171577582318d8a940d00399f59dba81c5"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
