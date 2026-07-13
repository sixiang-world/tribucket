class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.42.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.42.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "4d5663fc54704c23918310300094b764d82aac61649a47f0d78e549a02f0d1e6"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.42.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "6fff96fc15dacbc29f4c1d2de63c2db9f5dc200af42493e5d874f82d4394c92f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.42.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "020eefb3c1ec09de5f137e903e3cecedc0cb598938c58b1d1cf067075687d20d"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.42.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8b1ac9ec90360cc45e96eed90ddd109d19625762eb49c8df2e71f63453920827"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
