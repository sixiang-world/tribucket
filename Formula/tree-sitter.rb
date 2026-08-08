class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.26.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.12/tree-sitter-cli-macos-arm64.zip"
      sha256 "3ca18160518d0ac8f631448c771ac102748482af518992adcb09f96423ba153f"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.12/tree-sitter-cli-macos-x64.zip"
      sha256 "37102afe56fbcc6975c9f8e76a7bfbd383f28484e9a34e3acfeaf280a7f8c8c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.12/tree-sitter-cli-linux-arm64.zip"
      sha256 "be970bfad7b557ffc62b1a7b4c92341a9c6e16d619e9880e43f07c4a4e6eb52a"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.12/tree-sitter-cli-linux-x64.zip"
      sha256 "c33ace12fa7a94d09c97054da621bf7a6a3159f765b1839a898232de283d641d"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
