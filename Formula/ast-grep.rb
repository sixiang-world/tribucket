class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.51.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.1/app-aarch64-apple-darwin.zip"
      sha256 "a95772097b4d02bd9d45ed63b300c37041ae3c36632b3bf19250cc7c10187dc4"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.1/app-x86_64-apple-darwin.zip"
      sha256 "302b92868fa1b0439f0927b1f31668e03636b12a8e646fb1a3cd8de816c78242"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.1/app-aarch64-unknown-linux-gnu.zip"
      sha256 "db02fae2d8eace5fc40c55242068882452dd03eab38a1d950d5fd981cf112926"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.1/app-x86_64-unknown-linux-gnu.zip"
      sha256 "42514f77ae0c8a25d7d32154d31d3e7e16f3ab894f8ce76ce417de234ee49157"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
