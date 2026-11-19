class Delta < Formula
  desc "A syntax-highlighting pager for git, diff, and grep output"
  homepage "https://github.com/dandavison/delta"
  version "0.21.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dandavison/delta/releases/download/0.21.1/delta-0.21.1-aarch64-apple-darwin.tar.gz"
      sha256 "410442570af59c7d8d7f1303abfdc41ba8abc7527a1be697fd03546edeaba9d6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dandavison/delta/releases/download/0.21.1/delta-0.21.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "efe38626967f550c1d3bbe2014990dff5c8028a0a65a3f9b9b6c4a3bb53bfa28"
    end
    on_intel do
      url "https://github.com/dandavison/delta/releases/download/0.21.1/delta-0.21.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3fa53f78b8d63f2c0620aad591441e7d47b5c77e552869aa6fe21fd08b21ff6"
    end
  end

  def install
    bin.install Dir["delta*"].first => "delta"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delta --version 2>&1", 1)
  end
end
