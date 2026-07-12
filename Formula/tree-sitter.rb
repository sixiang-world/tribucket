class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.26.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.11/tree-sitter-cli-macos-arm64.zip"
      sha256 "050f41d60a054b608ea392ba14722bba9457bdc0ab11a5706c77f034dafc68ac"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.11/tree-sitter-cli-macos-x64.zip"
      sha256 "e3c2cdec71bbc60344b25df3dad5da378a174f2292af953ff0d641e06aaee099"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.11/tree-sitter-cli-linux-arm64.zip"
      sha256 "db28509fe6db8902f9d14c43c486858c7486b42c3a96b30e811e73f105762336"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.11/tree-sitter-cli-linux-x64.zip"
      sha256 "ff1b7f9863f2faafd78dc0e66d902ee85b37f709b314b22c009f51caf233eebd"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
