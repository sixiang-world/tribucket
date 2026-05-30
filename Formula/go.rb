class Go < Formula
  desc "Go programming language - compiled, concurrent, garbage-collected"
  homepage "https://go.dev/"
  version "1.24.3"
  license "BSD-3-Clause"

  on_macos do
    on_arm do
      url "https://go.dev/dl/go1.24.3.darwin-arm64.tar.gz"
      sha256 "64a3fa22142f627e78fac3018ce3d4aeace68b743eff0afda8aae0411df5e4fb"
    end
    on_intel do
      url "https://go.dev/dl/go1.24.3.darwin-amd64.tar.gz"
      sha256 "13e6fe3fcf65689d77d40e633de1e31c6febbdbcb846eb05fc2434ed2213e92b"
    end
  end

  on_linux do
    on_arm do
      url "https://go.dev/dl/go1.24.3.linux-arm64.tar.gz"
      sha256 "a463cb59382bd7ae7d8f4c68846e73c4d589f223c589ac76871b66811ded7836"
    end
    on_intel do
      url "https://go.dev/dl/go1.24.3.linux-amd64.tar.gz"
      sha256 "3333f6ea53afa971e9078895eaa4ac7204a8c6b5c68c10e6bc9a33e8e391bdd8"
    end
  end

  def install
    bin.install Dir["go*"].first => "go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go --version 2>&1", 1)
  end
end
