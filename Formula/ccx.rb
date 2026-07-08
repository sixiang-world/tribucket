class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.37"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.37/ccx-darwin-arm64"
      sha256 "f740240057216694f874c737e2622c2642421341d87c1e92eda14df92a4183a1"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.37/ccx-darwin-amd64"
      sha256 "63859f2e73256542fca928ada2b2000592d2019c9344c70e9ffbafef2cca0c3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.37/ccx-linux-arm64"
      sha256 "042497d54b56edf67b43278df11df9be89234e6556566dc8efaab111bf5df30f"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.37/ccx-linux-amd64"
      sha256 "a5a2e5fde00a4a4d1f29c6af4bb8e95fbfc71b7ab84cfbcb650871d1163ce2cd"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
