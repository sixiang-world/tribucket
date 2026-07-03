class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.29"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.29/ccx-darwin-arm64"
      sha256 "30019aa5b93524b2ebb2ae564deeb825d1b2d203e51b2a851d97387e65267c03"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.29/ccx-darwin-amd64"
      sha256 "21fcd26e43da74850a315b3954027da114d12c86a0281ce216eb5192d26c2011"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.29/ccx-linux-arm64"
      sha256 "4f90d13d137607cbbf88eeabe7fd7f8df74d0fdbb147682df079c345b4a7efcc"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.29/ccx-linux-amd64"
      sha256 "054adc819be132e79ddbdc9bbcd29142193720f85f98a37ff7b990b63b66ea57"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
