class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.9/codewhale-macos-arm64"
      sha256 "a083b6085ec3da030771634e806717bf08cc3b97a9a111b5d97e25fad353b6ba"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.9/codewhale-macos-x64"
      sha256 "cc29b842d1c96079032c3846ff41b290282d8019420c97fb922c68997d86d839"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.9/codewhale-linux-arm64"
      sha256 "9fec70aaea5f60da44f1a33278787c1bb57a1bdc11068bb0c921618482f4afb6"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.9/codewhale-linux-x64"
      sha256 "72acd677549d9f95fe55acb576d38fa4e87d4a2e722bed4270e243654af61f7d"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
