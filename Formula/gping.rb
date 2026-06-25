class Gping < Formula
  desc "Ping with a graph"
  homepage "https://github.com/orf/gping"
  version "gping-v1.20.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.4/gping-macOS-arm64.tar.gz"
      sha256 "124e5c44dd05abd8f2019bb23e31cc32d700e7f2f15f74692afde53b8c30a24f"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.4/gping-macOS-x86_64.tar.gz"
      sha256 "b39e8ed591117ca4366502d68ad59e7ade46cdd789853ea78a705ff5f7053d55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.4/gping-Linux-gnu-arm64.tar.gz"
      sha256 "a912b76238bf73d4ae6a4a2ada7f6dd42c25da37e8f0044f72543323656f7631"
    end
    on_intel do
      url "https://github.com/orf/gping/releases/download/gping-v1.20.4/gping-Linux-gnu-x86_64.tar.gz"
      sha256 "91dbcc0a2e279f7c91d9155f846fa5ad2626406f3306138ed2495744aaa9bc84"
    end
  end

  def install
    bin.install Dir["gping*"].first => "gping"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gping --version 2>&1", 1)
  end
end
