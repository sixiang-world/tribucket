class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.51.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.3/app-aarch64-apple-darwin.zip"
      sha256 "7954eab1e2803d1485f263377be7f359db6d3915312b5d773cd575eb009330b1"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.3/app-x86_64-apple-darwin.zip"
      sha256 "af04ed50179e51316a0139b8bb39502a3841d6c8e9fd9a4bac40987a8c7c3acd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.3/app-aarch64-unknown-linux-gnu.zip"
      sha256 "5b44fd68e78744934b359b07badce347d4197ed50b341d50f1f99d056ecedb08"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.51.3/app-x86_64-unknown-linux-gnu.zip"
      sha256 "22803eb0c5bf83164fb7fd76d4721d355ecf0c8466ef47342c1ec7d80897ca47"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
