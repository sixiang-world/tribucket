class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.67"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.67/codewhale-macos-arm64"
      sha256 "2c3d74035ff533c8bf39b9126e254c14d4c90d2f4edec5f58586d3863fef57a7"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.67/codewhale-macos-x64"
      sha256 "9a167f4275025f524bf0979f6e71a018d268288779e799508a98302327128fa3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.67/codewhale-linux-arm64"
      sha256 "e9d7b17b20478f417b3e6a1a77414ab32c3c528e92b1c317e75d182de874b179"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.67/codewhale-linux-x64"
      sha256 "c65d3643a6b5ffe5c8f9875f1c30df8199765b64cb9daf66b8383d45d9fcab4b"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
