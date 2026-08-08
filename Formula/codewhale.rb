class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.5/codewhale-macos-arm64"
      sha256 "57c767e689471c6faf14768212c523c7e5056ff1449bc96f7338400d2340eae2"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.5/codewhale-macos-x64"
      sha256 "a7a21e59ab60a46d13a4f73200410e82cca2d32e15d8717e64f28f9b9d19806f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.5/codewhale-linux-arm64"
      sha256 "d882c620273298a5b096345c3762b83653518aa878118cb8ceb5e8be15f0c1e2"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.5/codewhale-linux-x64"
      sha256 "19986b12c005ad6e140203595254c611933b85a86b3affcc63c5440afa388f27"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
