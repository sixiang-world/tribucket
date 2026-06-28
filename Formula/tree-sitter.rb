class TreeSitter < Formula
  desc "Parser generator tool and incremental parsing library"
  homepage "https://github.com/tree-sitter/tree-sitter"
  version "0.26.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.10/tree-sitter-cli-macos-arm64.zip"
      sha256 "47a1ee94f39611d28c79baa61a3f7bdb5fd1b076428f18fd8082628dc2eca2da"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.10/tree-sitter-cli-macos-x64.zip"
      sha256 "0c3fa553e1b7b1ca800516c677df18a0615af4f564f797b24cef6b1bb4ec2084"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.10/tree-sitter-cli-linux-arm64.zip"
      sha256 "6a455e6c0c21ddb732d182e3c46e3a8ca1121718254ce684a9dc730ff2367e02"
    end
    on_intel do
      url "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.10/tree-sitter-cli-linux-x64.zip"
      sha256 "5aca1172aae08050d0d1184046377d850c04065205185ebafde361afff8d9f62"
    end
  end

  def install
    bin.install Dir["tree-sitter*"].first => "tree-sitter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tree-sitter --version 2>&1", 1)
  end
end
