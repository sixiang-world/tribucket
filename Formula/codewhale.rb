class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.0/codewhale-macos-arm64"
      sha256 "e4596cf45e9230a9753b783ea6a7b1cce121a2037494943ca1d8623c5839e6c8"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.0/codewhale-macos-x64"
      sha256 "ec2fe4d2c6520accf946df282730056e0820553159558efb7678dfc78bcdbed5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.0/codewhale-linux-arm64"
      sha256 "ea6082245df89fb03e79696b4c7b775a73916ab2d1d4eef05c0dfa911d321f43"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.0/codewhale-linux-x64"
      sha256 "a01749d4d0f4cebbf1fb62e5c9f393cb5c05b570da144176238e740552de8fca"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
