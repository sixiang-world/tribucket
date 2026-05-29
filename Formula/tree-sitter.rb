class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.26.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.9/tree-sitter-cli-macos-arm64.zip"
      sha256 "86e81a78eee96f4fd730e43589ecc80263f7e34be7a0558ccebff9a492e8ad97"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.9/tree-sitter-cli-macos-x64.zip"
      sha256 "0df1a612b02cc6816a8cf045850f17f1542899942605cc4b6e549c0d903774f3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.9/tree-sitter-cli-linux-arm64.zip"
      sha256 "8b6c0f53593ce17c7eb90eb08de5ffb9f513f3db585b1fbef12219cacf7e8a68"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.9/tree-sitter-cli-linux-x64.zip"
      sha256 "0ea5daaef79145fe73786f0e3cdc43b62b22ddb36f7f6676c9f8bb72434d78e9"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
