class OblivionDesktop < Formula
  desc "Unofficial Warp Client for Windows/Mac/Linux"
  homepage "https://github.com/bepass-org/oblivion-desktop"
  version "3.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bepass-org/oblivion-desktop/releases/download/v3.11.0/oblivion-desktop-mac-arm64.zip"
      sha256 "6a356cd8069b7e56ab352804fb57f01bf7acfdd247e0d129a2f295ae33d8e1aa"
    end
    on_intel do
      url "https://github.com/bepass-org/oblivion-desktop/releases/download/v3.11.0/oblivion-desktop-mac-x64.zip"
      sha256 "86e42dbc98a422328d6904fea95c0d111a8724149cd2c01ec0c10c364024fd4c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bepass-org/oblivion-desktop/releases/download/v3.11.0/oblivion-desktop-linux-arm64.tar.xz"
      sha256 "3e7b0686104da6c69320291ffa3939ac88c962a68ca6a6a0f706530551e18e87"
    end
    on_intel do
      url "https://github.com/bepass-org/oblivion-desktop/releases/download/v3.11.0/oblivion-desktop-linux-x64.tar.xz"
      sha256 "9075ce2b60b7a02329f74e2b6d02a1647898940df506c87227acc1ad4931caf2"
    end
  end

  def install
    bin.install Dir["oblivion-desktop*"].first => "oblivion-desktop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oblivion-desktop --version 2>&1", 1)
  end
end
