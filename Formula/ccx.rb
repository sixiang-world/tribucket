class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.9.36"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.36/ccx-darwin-arm64"
      sha256 "4f27c500b5da554c33ccf5c7e0522231609c45b470d352ceff76a46d85ff2342"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.36/ccx-darwin-amd64"
      sha256 "d6c54376380821888a618a2ec1bd0110b8a2dfe1a9675c0616175a0b171ba600"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.36/ccx-linux-arm64"
      sha256 "d746e1d43fe72c67a7bf27d87d657644cd2f2753bd2604902200c249eea0d850"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.9.36/ccx-linux-amd64"
      sha256 "1b8ac13b83f08db4874912dec8b086e9706d7f5514cd6d2fc963f5b6055cecc4"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
