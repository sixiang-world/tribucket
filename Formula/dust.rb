class Dust < Formula
  desc "More intuitive version of du (disk usage)"
  homepage "https://github.com/bootandy/dust"
  version "1.2.6"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.6/dust-v1.2.6-x86_64-apple-darwin.tar.gz"
      sha256 "7603c92462bd56305847732eb25d70ab06386d7bcfbce7532b7cf3937fd9684f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bootandy/dust/releases/download/v1.2.6/dust-v1.2.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ec6a63bc275a33000443d444fd5424e56745aa995bc88e1080cd951e5e9e5cbf"
    end
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.6/dust-v1.2.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "14f788707aad217667f6812cf1a9639bf5c861a2ee815d486cffc36051f5e759"
    end
  end

  def install
    bin.install Dir["dust*"].first => "dust"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dust --version 2>&1", 1)
  end
end
