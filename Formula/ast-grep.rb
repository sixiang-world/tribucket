class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.51.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.2/app-aarch64-apple-darwin.zip"
      sha256 "ea4f4082d25e5f8e0450add6fd488dd008a373c90483cc2031759c8431f1dcfb"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.2/app-x86_64-apple-darwin.zip"
      sha256 "ef347c331d97cb6a043809091bd96bdd64de6a8354f01da66764496885230591"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.2/app-aarch64-unknown-linux-gnu.zip"
      sha256 "c3ab2bd43959db28621dc1551c13ea5fe5db4c1fc7b18086dade6b65042c78d0"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.2/app-x86_64-unknown-linux-gnu.zip"
      sha256 "40604c21c38d4c7581c56bdddeef277c56bf3c0113620aa96e78ae87e82366df"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
