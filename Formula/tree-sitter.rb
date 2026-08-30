class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.27.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.0/tree-sitter-cli-macos-arm64.zip"
      sha256 "f278063d8544160f6f89f7f8dba6ba112cb0dd1669757788d2bb7a8a613d2c58"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.0/tree-sitter-cli-macos-x64.zip"
      sha256 "4509c86918341ca50877ce20ef1507390257d203b4893f6c66b6f5cc632a61cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.0/tree-sitter-cli-linux-arm64.zip"
      sha256 "6260b621bf5ab87027dfb463bf955504ef32cdcda62b81f28447753e48c83a62"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.0/tree-sitter-cli-linux-x64.zip"
      sha256 "e4a3826bcd0fe099ee3a5617767374939cbc23c4a35b5b53f5fc04142525a2c1"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
