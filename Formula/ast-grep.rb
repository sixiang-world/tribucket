class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.45.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.3/app-aarch64-apple-darwin.zip"
      sha256 "6d2279dea5bea2ad79c66ea93f5fe54ba926e398a8a26de76c56db68fe59eac6"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.3/app-x86_64-apple-darwin.zip"
      sha256 "b2ffd26f42810340326a9e8a084bdc3647a8795c1a3f21fc06bd7bef3c7c5b2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.3/app-aarch64-unknown-linux-gnu.zip"
      sha256 "b39cfbc58da4b869a88b8a4bc57bd5deb0d24541e704cf7c257da7b53ec81c8f"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.3/app-x86_64-unknown-linux-gnu.zip"
      sha256 "f8ac830881339d1edee6b2652f54798c0f4da5a827f2db38a08ee31117783ce8"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
