class Yazi < Formula
  desc "Blazing fast terminal file manager"
  homepage "https://github.com/sxyazi/yazi"
  version "26.5.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sxyazi/yazi/releases/download/v26.5.6/yazi-aarch64-apple-darwin.zip"
      sha256 "7abd71725e2fe27bed036becbf6ce79fa17964eb68491d34190011c94b8c7ca8"
    end
    on_intel do
      url "https://github.com/sxyazi/yazi/releases/download/v26.5.6/yazi-x86_64-apple-darwin.zip"
      sha256 "6846066f992c1688d8ec77431a3ab53f5ef268019fcef86e5649b8c27010868d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sxyazi/yazi/releases/download/v26.5.6/yazi-aarch64-unknown-linux-gnu.zip"
      sha256 "c38b07961e7fc4c76503fd0f4a1b4bd0b379a99835b818cd899b0315c728e1e1"
    end
    on_intel do
      url "https://github.com/sxyazi/yazi/releases/download/v26.5.6/yazi-x86_64-unknown-linux-gnu.zip"
      sha256 "1c9096f0a83b8102c194385f644cdeff93cc8269426163c9d033041ebd537bd2"
    end
  end

  def install
    bin.install Dir["yazi*"].first => "yazi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yazi --version 2>&1", 1)
  end
end
