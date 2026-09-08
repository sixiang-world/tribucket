class Goose < Formula
  desc "Open-source AI agent by Block — extensible, runs in terminal"
  homepage "https://github.com/block/goose"
  version "1.50.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.0/goose-aarch64-apple-darwin.tar.gz"
      sha256 "6f1f1fb56868996af2652e8b5334d29f970e56836e200c4ff57e92de2496fccb"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.0/goose-x86_64-apple-darwin.tar.gz"
      sha256 "4bfb0238d8ec54343f683ef28506d609e5889861f0fd2f6a3c91fb8b02aa7dd7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.0/goose-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "febd71a6a25c3aff7dbcf566f78d2864e87d886c33c4ef1fee2f67fedd334063"
    end
    on_intel do
      url "https://github.com/aaif-goose/goose/releases/download/v1.50.0/goose-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6389eea4440178de006fa148d466ac411021315ff7f72b1014beae2d445851e2"
    end
  end

  def install
    bin.install Dir["goose*"].first => "goose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version 2>&1", 1)
  end
end
