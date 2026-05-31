class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.48"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.48/codewhale-macos-arm64"
      sha256 "20619455d3e4ccc3c9bf6a673fd0e3215da4f06b0221f448b67eb411b4840689"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.48/codewhale-macos-x64"
      sha256 "ea596aa764831bb80e0f142f527372b2ac3ba10ca77ca8b0ef7b4d561d73abd3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.48/codewhale-linux-arm64"
      sha256 "b902467cbf77f39ee76f1d52f35002fb0b37a4a89ac9fefda0b1782f56b6e59d"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.48/codewhale-linux-x64"
      sha256 "28a521445ad6e047c7d213b0948e35eaf069f77ce4c8100b0763075711f4febe"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
