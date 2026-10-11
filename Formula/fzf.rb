class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.74.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.5/fzf-0.74.5-darwin_arm64.tar.gz"
      sha256 "ada808c7401b9949ce8842274ac16a6b6193fd32dcada396884a6a9a89e5985a"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.5/fzf-0.74.5-darwin_amd64.tar.gz"
      sha256 "aca6cab692e6c069e724a43070a448e18586c7c0fdd1139f6d487ec1680599ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.5/fzf-0.74.5-linux_arm64.tar.gz"
      sha256 "cf058001da21724a469b714a29cf4aab9cbe860d218a0d6c1b5b661efad7784c"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.5/fzf-0.74.5-linux_amd64.tar.gz"
      sha256 "d47d7f882972c7d674dbbba998ffa4116e68379616ffac7695d0671e9a722c5f"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
