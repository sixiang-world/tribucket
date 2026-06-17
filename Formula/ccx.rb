class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.1/ccx-darwin-arm64"
      sha256 "8c2ae26faea05804f9d9fec6ccf1a0f82c1f724c5c933a76960a19f10aca5ec1"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.1/ccx-darwin-amd64"
      sha256 "37394dacd4f8b0b8460b40eede4a7457c18868c69560c0ac191f1b8573964f67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.1/ccx-linux-arm64"
      sha256 "01ebf09bdd966238dfeacbd7a0a44027ebf92f5f752abfead529dd6191e18ade"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.1/ccx-linux-amd64"
      sha256 "803bdbe0dfa01acae0008e2938d00c6e61b6fbfa9ec5ea2a2dd93a58f53bf7aa"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
