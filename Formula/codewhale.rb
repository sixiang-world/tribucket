class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.12/codewhale-macos-arm64"
      sha256 "68b22dca80bffb13ba97a10794a4d54206cf1abc0a6a9df2e499ce2057ccb724"
    end
    on_intel do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.12/codewhale-macos-x64"
      sha256 "96424a533be04ae14ec2eeecfe1eb7d56a6b0fe36b5be01eeb3e6c4f1e89bee2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.12/codewhale-linux-arm64"
      sha256 "1a48def4032e88d808471c6feaa5a6c902fb584c085cc758cc1d297d38dbda13"
    end
    on_intel do
      url "https://github.com/Hmbown/Codewhale/releases/download/v0.9.12/codewhale-linux-x64"
      sha256 "9d0b74d8d3bf1021f9e8ca502650b76d2172e7fb9dd6d475a7e43ba7c730e7f1"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
