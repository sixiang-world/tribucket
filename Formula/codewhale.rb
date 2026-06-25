class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.65"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.65/codewhale-macos-arm64"
      sha256 "9afcdbcc910c142ada31467b6a5e4ac76b9b46c90229418bf156e627ecac924c"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.65/codewhale-macos-x64"
      sha256 "9be7d5022ad434c093b6c851580a2a9853adac7b9cc92c6eca29f45b0d69974e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.65/codewhale-linux-arm64"
      sha256 "48b40ec62e3c5dabdfc141345b81b2fcd6bec21baedac479eaf5d71d3266c14b"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.65/codewhale-linux-x64"
      sha256 "243ebdb823613b6edcad404b507aa985075f009aab00f388aeaeb94cddae1c51"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
