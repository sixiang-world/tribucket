class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.27.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.2/tree-sitter-cli-macos-arm64.zip"
      sha256 "2f5645377a5f99ce0b019a316a9a2f17457a53d6f494eff437433db69b6fc363"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.2/tree-sitter-cli-macos-x64.zip"
      sha256 "7a44003e536a9074fca2693d83af4d6e9a746b47049f9a6971e3bd91d55e2313"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.2/tree-sitter-cli-linux-arm64.zip"
      sha256 "4598875d129dfef384b3d78da329b766f151c2f827404fb5f3363a135935d0d3"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.2/tree-sitter-cli-linux-x64.zip"
      sha256 "b4233ecc4f0e648d6d8ccc4bac96c00c712ca1a5eb1e0ca7197d29b750bffa6d"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
