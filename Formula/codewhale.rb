class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.66"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.66/codewhale-macos-arm64"
      sha256 "6b47069fb02fccbe82cdba45eb8812579fba63478d9803074ac1fbbe96419993"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.66/codewhale-macos-x64"
      sha256 "b2c7f1379bff05700862e25b33f8c3e181694cfccc815facd6f226b455938edb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.66/codewhale-linux-arm64"
      sha256 "7f1c82ee4509cd0db1cacaa93fda45e9b4b3e8bfb992bbba32c543f08edf4bb4"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.66/codewhale-linux-x64"
      sha256 "f787f68f55f5e4474e47dfa8d4725f71f03f5fbc117548d597003d045982f91f"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
