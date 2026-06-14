class Codewhale < Formula
  desc "DeepSeek + MiMo coding agent in terminal"
  homepage "https://github.com/Hmbown/CodeWhale"
  version "0.8.60"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.60/codewhale-macos-arm64"
      sha256 "3e923b2c57e1dc0ba91bae9bd65b96985894d5362ff49a8438bb9537ccdc0890"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.60/codewhale-macos-x64"
      sha256 "72522cacd43c624f3d7f0ef428338dc0d82ed51e6daaa88c7d99474c7eddc985"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.60/codewhale-linux-arm64"
      sha256 "c634f08814275c9c3ec29790c0d0f75f34b56bd8d33ae1b471abd22913b94e2d"
    end
    on_intel do
      url "https://github.com/Hmbown/CodeWhale/releases/download/v0.8.60/codewhale-linux-x64"
      sha256 "26a941c84947a0b711d8c9709b1e507337e3f84a00a7e8a074b09dfd050eb17e"
    end
  end

  def install
    bin.install Dir["codewhale*"].first => "codewhale"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codewhale --version 2>&1", 1)
  end
end
