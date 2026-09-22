class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.10.0/codewhale-macos-arm64"
      sha256 "25774dadc725272f56a1734f1d2b24dd1051e9b43d7b39a30c460dfbbb0bb6e4"
    end
    on_intel do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.10.0/codewhale-macos-x64"
      sha256 "2ab6a8c73333cb70dd951229c38ea13ac9a9b24dbd64dcf605ec55d2958d5456"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.10.0/codewhale-linux-arm64"
      sha256 "f3e2d82257cac33ef033f033a9638cb00189a3334deb58fbff7b89aed218273a"
    end
    on_intel do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.10.0/codewhale-linux-x64"
      sha256 "c443c2c32c743dd80ff56397b1e7bbfe55b1ca6306ff55065b977bc655d50ed1"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
