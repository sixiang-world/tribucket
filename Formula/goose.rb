class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.55.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.55.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "153425d6dc3a49afce85e70009eff87f6020e3ed029bb56fae1b523f7f2d8107"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.55.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "2b1001ba0a5d0064b7a28b84d6bb53c91ab5f63916e86c8b4bc688240dcf392e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.55.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ea83f59bb165a3d999dd00edf69a58028747f31e404b96f0153452c6b1651188"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.55.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd3932908328fac850ca7ad2a8289c744e0c2ddaf4c5a2338709fb17a00b3a4c"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
