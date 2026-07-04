class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.44.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.1/app-aarch64-apple-darwin.zip"
      sha256 "0a2fef273b0ff1238b8307add911714f92021d25b919fa3ec9b6b2e046bb29cf"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.1/app-x86_64-apple-darwin.zip"
      sha256 "46584f3e4f67e9ae482de69e71e4e4aa88e68da322316fdd25ad73f2621ddbc5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.1/app-aarch64-unknown-linux-gnu.zip"
      sha256 "077a4ab0c628154ef3cb79fecaf11dabca7f8a41f2c7260c022f263a52c1b021"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.1/app-x86_64-unknown-linux-gnu.zip"
      sha256 "611f9e5e76f2611ecea1a35dd3468ceedf600641a11224b80341d79c6ee7b9dd"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
