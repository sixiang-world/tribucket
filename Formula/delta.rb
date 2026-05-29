class Delta < Formula
  desc "A syntax-highlighting pager for git, diff, and grep output"
  homepage "https://github.com/dandavison/delta"
  version "0.19.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/dandavison/delta/releases/download/0.19.2/delta-0.19.2-aarch64-apple-darwin.tar.gz"
      sha256 "9be36612a5a13e9e386dc498fb8e50dc87c72ee42b63db0ea05b32f99a72a69a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/dandavison/delta/releases/download/0.19.2/delta-0.19.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0bfce159a5cddd5feb3d6db4a616d883ff51253ce08ac7ec11cb1d208cfaab9e"
    end
    on_intel do
      url "https://github.com/dandavison/delta/releases/download/0.19.2/delta-0.19.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e695c5f586a8c53d6c3b01be0b4a422ed218bfed2a56191caebe373a1c18ab2"
    end
  end

  def install
    bin.install Dir["delta*"].first => "delta"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delta --version 2>&1", 1)
  end
end
