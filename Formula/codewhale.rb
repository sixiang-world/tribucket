class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.1/codewhale-macos-arm64"
      sha256 "9150fb86e07e61b41346c8805ad8c0750ef91ef213543216cd093803f61117e6"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.1/codewhale-macos-x64"
      sha256 "92a38d4a5a6ca5be22fa4894478de146424bcb42ceb53a66b35c453f4b1b8339"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.1/codewhale-linux-arm64"
      sha256 "0a51f5850e278287f25f0f8352dd515fa53896ccf4b1e083c3ef594cc6033579"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.9.1/codewhale-linux-x64"
      sha256 "d4bc2d1908a78c5cbe6974a6e16ca8a06690775e454e73b7f6b5548f033b5bc2"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
