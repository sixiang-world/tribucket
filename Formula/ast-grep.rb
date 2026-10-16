class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.51.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.0/app-aarch64-apple-darwin.zip"
      sha256 "e18e13c27ed6c4b3ec4de00745b0755dee9dc26c035e226f4dd5d147dca99cc8"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.0/app-x86_64-apple-darwin.zip"
      sha256 "8438fe549da59da28518c45bdaab5b851aabafe8fb4f8dc05c261a7649b4eca6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.0/app-aarch64-unknown-linux-gnu.zip"
      sha256 "73af0ebe5958acee012754a5b2826a186580ef83333092408a7a01096fc30b8b"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.0/app-x86_64-unknown-linux-gnu.zip"
      sha256 "a7eead5552d3a8daad70f5d50d935da44bd0c138e946b5b0a96b1d38169fa639"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
