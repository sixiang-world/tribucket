class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.60.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.60.1/goose-aarch64-apple-darwin.tar.gz"
      sha256 "b4aa2a370ef26fea4727f4a117faa19e1b3d15b2777561904ae3763b11782a9f"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.60.1/goose-x86_64-apple-darwin.tar.gz"
      sha256 "c55d49b6edf0d81ffdc776cb4a239442f5da05e2df225b67640ec1ac510fe5cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.60.1/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6a962a0ba55829e00f6f297dff736d53b9bdc8da84f0f49c4768e2557ac39cbe"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.60.1/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0327b1857f8030343f59b77503e0455629bbf472c2901cb94b88389d6278635a"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
