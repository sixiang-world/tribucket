class Zola < Formula
  desc "A fast static site generator in a single binary with everything built-in"
  homepage "https://github.com/getzola/zola"
  version "0.23.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.6/zola-v0.23.6-aarch64-apple-darwin.tar.gz"
      sha256 "cbffbd29b3f59c3f52633507c8cb945a7a02d8b1399b43b235f5932912297aa3"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.6/zola-v0.23.6-x86_64-apple-darwin.tar.gz"
      sha256 "79a4d0ab51a4d863c068e6e594c6fce36f0aa17429a414ea63066f5910d14460"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getzola/zola/releases/download/v0.23.6/zola-v0.23.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "266448fffbf7c7004ca399d0e76dd699541771096d8a42aede98cebe2a029d02"
    end
    on_intel do
      url "https://github.com/getzola/zola/releases/download/v0.23.6/zola-v0.23.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8f5132b3522412d04e395e0b25f6d68613ad272a873e54a2b3ebf664873024a4"
    end
  end

  def install
    bin.install Dir["zola*"].first => "zola"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zola --version 2>&1", 1)
  end
end
