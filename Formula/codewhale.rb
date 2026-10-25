class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.10.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.2/codewhale-macos-arm64"
      sha256 "da0229610647f1cc2dd14c4227b333a92ea276a49f5d4d79160fa19e515e590d"
    end
    on_intel do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.2/codewhale-macos-x64"
      sha256 "ac135d8961525b4092101a15874016d42f71ef821c9c34db3b8f936aad9cb988"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.2/codewhale-linux-arm64"
      sha256 "b7c55e36f7ef30c8fae4b8741bfaf9e0177220a9d4d6d3e26650609b4d9ffe90"
    end
    on_intel do
      url "https://github.com/codewhale-hq/Codewhale/releases/download/v0.10.2/codewhale-linux-x64"
      sha256 "28ac984a2f145bf99b29933498a3f951a591283c22782933ce933861dda6c70b"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
