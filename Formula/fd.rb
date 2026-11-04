class Fd < Formula
  desc "A simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  version "10.5.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.1/fd-v10.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "2d336895ed27b14c5cc9fc5eb22df03b3ee842b5dce80060e99d9cdc1b1b9fc7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.1/fd-v10.5.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "86800e7dbe423cc7ed14076f40983f1bc739a299ca9a5ae5604cf261a87b3865"
    end
    on_intel do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.1/fd-v10.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d0e2b438c8c4946955f05e4cf51452deada8f7ed509e1ccd60235a468622716f"
    end
  end

  def install
    bin.install Dir["fd*"].first => "fd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fd --version 2>&1", 1)
  end
end
