class Watchexec < Formula
  desc "Execute commands in response to file modifications"
  homepage "https://github.com/watchexec/watchexec"
  version "2.7.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.3/watchexec-2.7.3-aarch64-apple-darwin.tar.xz"
      sha256 "bb2a3acc02de5c64f87779fc0226274d47d79026c6df969c8c1034a110b2efad"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.3/watchexec-2.7.3-x86_64-apple-darwin.tar.xz"
      sha256 "ddca28bbd6b219a14ffec4893d56dad2e29cfc8b3e47f49e275706c9af20b4c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.3/watchexec-2.7.3-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02b3e2beddf96fef5fb2b88849902e3cf9e96da87968bdfb7a488700d64142cc"
    end
    on_intel do
      url "https://github.com/watchexec/watchexec/releases/download/v2.7.3/watchexec-2.7.3-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ace3a1d2e752d189f28b6766311d58f155ab977fae66aba60b111ec8aec2f64"
    end
  end

  def install
    bin.install Dir["watchexec*"].first => "watchexec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/watchexec --version 2>&1", 1)
  end
end
