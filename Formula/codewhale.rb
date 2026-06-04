class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.53"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.53/codewhale-macos-arm64"
      sha256 "2609a3e6f8265266b05e3f1c3d9c21b108aed245fbe0293939ad846be3cc54a5"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.53/codewhale-macos-x64"
      sha256 "e98b6e5d7c1a1c527a86e5a577d40cc93a6371956f7a25b74b98b69804ea2fac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.53/codewhale-linux-arm64"
      sha256 "a98fdc00ebff200d3ca2e2a678409a13e5ce8b9fb0d830eadc9adc6c807391db"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.53/codewhale-linux-x64"
      sha256 "57104d1f6a38884924d0fae7b991c33c40a3be6f8045747d4ff055f10aaf62dc"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
