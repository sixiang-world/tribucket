class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.59.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "0142839f339e3484b49326d69de9d9cf808999087ab421ae9304d2620e647cbc"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "1a15f649cabbdeccbb1905483a6c30681375653264273f022e03358ba53ad2ce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ba96b78394e3050077482bb285ff35f34613646e90b84a18b5d674b71905166e"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.59.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a774667de6c20206a60d78d7bece2d9dda8389667e4f5c2fc8aaa758d1e81ef3"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
