class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.45.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.1/app-aarch64-apple-darwin.zip"
      sha256 "6c761afbdc072a7a9006d0dc5c49b3247fef195b8bebe675b4aa385ff872d9c3"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.1/app-x86_64-apple-darwin.zip"
      sha256 "38ec2d1c7c97f1efc1c1080526e3c54b964e263478e347f44a65b5287ef5a6ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.1/app-aarch64-unknown-linux-gnu.zip"
      sha256 "9ee7ec49aada3dc05135d21977af089a33fc3154ada25bab102daca90b5098f2"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.1/app-x86_64-unknown-linux-gnu.zip"
      sha256 "76fb6555be6734fb5057dba8d2fb756430f374bb9e1af694cf1ce00e13238d63"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
