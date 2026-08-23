class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.26.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.13/tree-sitter-cli-macos-arm64.zip"
      sha256 "eeb4c0fd909187de2e77a6403ca9c748d41f209f1186cac0d38f38f571930c02"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.13/tree-sitter-cli-macos-x64.zip"
      sha256 "052f2866ad453bb39ab2905e5b7bbb9de670875f67483243cd9659c0503d97ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.13/tree-sitter-cli-linux-arm64.zip"
      sha256 "72c6d6c669c70491f93db290b285d9e85fd68ead9e324cc55ace35a1be66c3bd"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.13/tree-sitter-cli-linux-x64.zip"
      sha256 "1b781c0dc1dfefea44b5db2ec2a58440fe9d006856c3f5b3fd9a17119d1138a2"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
