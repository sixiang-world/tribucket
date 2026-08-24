class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.45.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.2/app-aarch64-apple-darwin.zip"
      sha256 "1fc21214234bf6f5a3f841d5b2493a4fc4b6087f69b055c9ad5f94f77c0ab76e"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.2/app-x86_64-apple-darwin.zip"
      sha256 "037e5b4a9aed2ba03a2b4710e4fe3439d5d1154d1266d5e8f9f6df7452169181"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.2/app-aarch64-unknown-linux-gnu.zip"
      sha256 "e67ee2f5928b4d77a472114edf6e227d90fefe22fa47e7a78db187c55d206564"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.2/app-x86_64-unknown-linux-gnu.zip"
      sha256 "67aff72dd2994bf152fcc3a8a09cf93b13193abe59f39393095167c729af2015"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
