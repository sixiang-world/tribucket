class AstGrep < Formula
  desc "Structural search/replace using AST patterns"
  homepage "https://github.com/ast-grep/ast-grep"
  version "0.44.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.0/app-aarch64-apple-darwin.zip"
      sha256 "80ad83ae28c56cbbaa2beaa391f564b073a99c2a0a20d49fd9ddc10aaafd6979"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.0/app-x86_64-apple-darwin.zip"
      sha256 "0df15196bd07a598dbc600feb95b5e707c062542be282d3f6ebd92436ef7777e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.0/app-aarch64-unknown-linux-gnu.zip"
      sha256 "86f4d5924b59fca4bbcb3fb2fb9a73b38a4f666c402886395c8bf18b6afc61f0"
    end
    on_intel do
      url "https://github.com/ast-grep/ast-grep/releases/download/0.44.0/app-x86_64-unknown-linux-gnu.zip"
      sha256 "a074982c59a749371d225e6129faf5815f731f460aa080c004af9b7e79c55632"
    end
  end

  def install
    bin.install Dir["sg*"].first => "sg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sg --version 2>&1", 1)
  end
end
