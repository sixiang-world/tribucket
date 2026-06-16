class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.61"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.61/codewhale-macos-arm64"
      sha256 "9575fe30c7a3eed44c20fa0a98cdc789b61eeea6982842c9c01a5ffc27b40f5b"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.61/codewhale-macos-x64"
      sha256 "1d6f09946152920b3310da7fb2628ddeff55abb3bcc5255626c9bf1dfbfbe5b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.61/codewhale-linux-arm64"
      sha256 "085b201eb76cbaa7ace7f209abec4110a366b3b7d694899166aeb3a1f8ded9c7"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.61/codewhale-linux-x64"
      sha256 "de4d0afc8fcdc581eb36cce09e24277164eef0746ab11dd14a0f982ee07e2246"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
