class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.57.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.57.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "80d43c49b77302777e9d2fe32faf3c40c1028dafbea1e0a39b0378404a8a074b"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.57.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "5ad5594246841c759b34966e09ca421c09151b589183a8f1720e15e8395834ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.57.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c32605acfd560aeb2adbf17ec359cc0217e28022a7e647b35a6af5dcfca91749"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.57.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "10eb96cb6a159b6e1d38eeedbef6ab64cd28168aad91948f1fa5c34eefdf98e3"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
