class Gping < Formula
  desc "Ping with a graph"
  homepage "https://github.com/orf/gping"
  version "gping-v1.20.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.2/gping-macOS-arm64.tar.gz"
      sha256 "4f63da3376abdc9e8bf4e8a562f57de911330fc416488eeaade39f8100018d2e"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.2/gping-macOS-x86_64.tar.gz"
      sha256 "7865f7fbca3ea63e411fd9e3059a79e061e9862c9cab10950391e60d7a853fac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.2/gping-Linux-gnu-arm64.tar.gz"
      sha256 "95fa83a26a6f5617b90610201df7ba99b2f1fe785919ed259317b5daee9b9739"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.2/gping-Linux-gnu-x86_64.tar.gz"
      sha256 "49ab921aa82d304e78b03ab10329cdbda3a9393731aa56ce53a1e2283b96f912"
    end
  end

  def install
    bin.install Dir["gping*"].first => "gping"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gping --version 2>&1", 1)
  end
end
