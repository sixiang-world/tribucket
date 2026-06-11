class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.58"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.58/codewhale-macos-arm64"
      sha256 "848beba882808e33e414289349e5e1eb0c150ac488ef23cf15e21a643d389364"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.58/codewhale-macos-x64"
      sha256 "a7f259296f48d7631847e42478b64226e07c289774ed95497a12f3fba0e59e6a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.58/codewhale-linux-arm64"
      sha256 "c360c176b8cd3d1d909ef0136a97458f100803aea47054197ad62c2b29cfe5aa"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.58/codewhale-linux-x64"
      sha256 "011f63259cc1d553547bbc9a2378e949426c5eece0bea93969678b59efcbfef0"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
