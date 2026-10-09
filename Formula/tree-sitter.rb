class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.27.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.1/tree-sitter-cli-macos-arm64.zip"
      sha256 "6362cda144b6e45d92c739d4eafb7e3c322f0545b0b959b4f7ca7d53fb3300fa"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.1/tree-sitter-cli-macos-x64.zip"
      sha256 "fd7e60f57b6e00caecaa055b94da20d7875b05cef2277831588546e08ab8bb29"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.1/tree-sitter-cli-linux-arm64.zip"
      sha256 "3c0d0113cae3fea36f2336c271cbdacbcdb349edb006319155652b9386803c55"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.1/tree-sitter-cli-linux-x64.zip"
      sha256 "c7e686aec16ba17053c2e6fd87600ccb10cf8ba3d055756b17e756d538e11114"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
