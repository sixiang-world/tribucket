class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.45.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.0/app-aarch64-apple-darwin.zip"
      sha256 "ec2e3680f4f84c68b48420bcca01d21389787c7318b52083dde6f46ac12ad946"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.0/app-x86_64-apple-darwin.zip"
      sha256 "78d0d9db2f4dfd964fd313e70e92571c6d4204243ad8f3d0abbb2ffc56e45fc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.0/app-aarch64-unknown-linux-gnu.zip"
      sha256 "62b60892dafacfa76d6de87157659f880bbf85ff38bdab52db12f1f14ec60f94"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.45.0/app-x86_64-unknown-linux-gnu.zip"
      sha256 "78931ae35ebac33d9a72b3aecea3e3d62d6e5b0b718ac8bbedfbe69d68421e41"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
