class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.7/codewhale-macos-arm64"
      sha256 "293d3112f6598941315203bbf9bb6549205bc020397e2270add0c70500f397b5"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.7/codewhale-macos-x64"
      sha256 "1c93a18a175ad6a0fe30d711e88b58d6d12bff0db6687eda60b0142e9b785bad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.7/codewhale-linux-arm64"
      sha256 "a4104e097920540a76b824050b14bdb07eb8347da26069e3c34388e3178efb13"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.7/codewhale-linux-x64"
      sha256 "74bcfb52b5b513fae608adbb8ed3d0303ef02714cc7836f5b7fd4704a2039891"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
