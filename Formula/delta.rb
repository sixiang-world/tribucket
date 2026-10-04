class Delta < Formula
  desc "A syntax-highlighting pager for git, diff, and grep output"
  homepage "https://github.com/dandavison/delta"
  version "0.20.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dandavison/delta/releases/download/0.20.1/delta-0.20.1-aarch64-apple-darwin.tar.gz"
      sha256 "bc1839cea69288d4673a24faffbb825d408ca907e0f7d33b1678c9e6cdd5e58e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dandavison/delta/releases/download/0.20.1/delta-0.20.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "da7f4338f593572ff426ae153e0870e2fdc72729416eff551b40cdeb67940db8"
    end
    on_intel do
      url "https://github.com/dandavison/delta/releases/download/0.20.1/delta-0.20.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "50f08c879f84c81ceb220e476491a7f492d2c9c671e79918cc44badf961a6240"
    end
  end

  def install
    bin.install Dir["delta*"].first => "delta"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delta --version 2>&1", 1)
  end
end
