class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.73.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-darwin_arm64.tar.gz"
      sha256 "d27fd68c04fb9b42f7c73a3f7d38069a74d308e40174f64a072c747213e97286"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-darwin_amd64.tar.gz"
      sha256 "75bbf15248d1cf0a13eafc75b8a55f5075c437e2ba6d76899afc53f4f3e1b38c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_arm64.tar.gz"
      sha256 "a408b0b6c08d486307b8f1554f967b8b50ee1b3ea8b4035e3161bab31fdfc28d"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_amd64.tar.gz"
      sha256 "f3252c2c366bc1700d3c85781ec8c9695998927ac127870eb049ceea2d540f8a"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
