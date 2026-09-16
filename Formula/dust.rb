class Dust < Formula
  desc "More intuitive version of du (disk usage)"
  homepage "https://github.com/bootandy/dust"
  version "1.2.5"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.5/dust-v1.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "29566236d7a5e2afbc3fcf2d365845a4eaf0fc969a4ed9f8b878bc1a4fc7d2b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bootandy/dust/releases/download/v1.2.5/dust-v1.2.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "83b8d5b068bdbfd1952a55c8419e77c413d1c084ce7f7369d28f9be36d66dd6a"
    end
    on_intel do
      url "https://github.com/bootandy/dust/releases/download/v1.2.5/dust-v1.2.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "64b16f5c10cc4c25d2eaa144e9d2d44b3ed8f72ee63b3bc0a92c85e21e9e0932"
    end
  end

  def install
    bin.install Dir["dust*"].first => "dust"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dust --version 2>&1", 1)
  end
end
