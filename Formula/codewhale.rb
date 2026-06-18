class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.62"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.62/codewhale-macos-arm64"
      sha256 "8876d4db01fc0312e6b88d62ff34eff6dc3df3106746024e1d1f78e29be8418f"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.62/codewhale-macos-x64"
      sha256 "504833a44b963be3bd2de9aa8014ae7d8c388a772f2b2fe40ea89277266da2c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.62/codewhale-linux-arm64"
      sha256 "46e301c0d9837983acc463580ba15f7c90988d8bbdf1a5812f1cb1f301187c0a"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.62/codewhale-linux-x64"
      sha256 "722dcca24196a320effc5d12cabdd51fe1966aaf5436a4d0b3464ecabb885761"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
