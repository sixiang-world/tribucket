class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.4/codewhale-macos-arm64"
      sha256 "1f6aad2e303c79ff7e9b63045fc9efb2b293e5d375185bc71d65d70c521addd6"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.4/codewhale-macos-x64"
      sha256 "7d85823066fcd5c4843490c90271f35f83bedd639142dbe1c3e840dbac970a90"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.4/codewhale-linux-arm64"
      sha256 "e79b25908a6557736879b6050245a0744fd5fde6d2819b68e32f0756724d357a"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.4/codewhale-linux-x64"
      sha256 "d1654c674df40b1f14516a3dbf812bf743eb8bad2704f204e4f034696c115cad"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
