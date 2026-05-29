class Ccx < Formula
  desc "Claude / Codex / Gemini API Proxy and Gateway"
  homepage "https://github.com/BenedictKing/ccx"
  version "2.8.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.17/ccx-darwin-arm64"
      sha256 "6b214f51227a4685ef5404291ba99333d9d4dc1a12cfe05bc99202ac18822226"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.17/ccx-darwin-amd64"
      sha256 "f013fc695ecf75d6cbf9ecab2cf686180b7faa2058d417034f12ec5917e563a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.17/ccx-linux-arm64"
      sha256 "ae962e5e1d7ab594d0988642ad0b17b60053bd737c2db6ef7110b513a2ec181a"
    end
    on_intel do
      url "https://github.com/BenedictKing/ccx/releases/download/v2.8.17/ccx-linux-amd64"
      sha256 "fa5b2216db6c8fdc91711a036ba293adf277e26e9869d06ccc4ce879399f8e51"
    end
  end

  def install
    bin.install Dir["ccx*"].first => "ccx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccx --version 2>&1", 1)
  end
end
