class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.49"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.49/codewhale-macos-arm64"
      sha256 "918f6a49bbb33186610cde7cbe4be4955f72467e6d259a6e4471686702c0fecd"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.49/codewhale-macos-x64"
      sha256 "e8b660f21f67c64b760d6db0ec4fcface5a9fa8807e29d6c879e0e502867c9a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.49/codewhale-linux-arm64"
      sha256 "394fdaa93c48233be54b784098a90c9a18db5cf4bac795ac46402de46f49d745"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.49/codewhale-linux-x64"
      sha256 "f7bce4e0bcda86ca55a9df14fd9f2b7d2eb4a0e58d50fb169f8c6d9ffacbf024"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
