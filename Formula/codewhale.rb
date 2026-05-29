class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.47"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.47/codewhale-macos-arm64"
      sha256 "c29b7f4792126ea8aad835a97da4340d428cdc68f8677537bf57b5beed5d7bde"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.47/codewhale-macos-x64"
      sha256 "5c3ed49d936dd2f2949e18498d58cae795ad3a4e953bdf79c9c8db6c4343a170"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.47/codewhale-linux-arm64"
      sha256 "9050075da0d4496b52edf237a59a21ccde8b60553cbc689e7aa5565957ebbed8"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.47/codewhale-linux-x64"
      sha256 "8386bc5d3f63c2dd2e29b570815546fd4f84235da56b686f4afe5d058138698f"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
