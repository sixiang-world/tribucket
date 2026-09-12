class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.74.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.4/fzf-0.74.4-darwin_arm64.tar.gz"
      sha256 "4f6a113bfc0c7959e0005c78d566a51afc4fcefc956f43735c62a9deb19e92ae"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.4/fzf-0.74.4-darwin_amd64.tar.gz"
      sha256 "2d392b50be66e2ab104ccd52a6072df692b1f9b9c5b449a9c098de885f32c4c5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.4/fzf-0.74.4-linux_arm64.tar.gz"
      sha256 "5d673b849f494f0d64ec471d8640b153ca8849e3846a31da17abdcfce8df6b46"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.4/fzf-0.74.4-linux_amd64.tar.gz"
      sha256 "05e6813a337cc722c3ed07e54a764b75cc5d671e2e60459db0ba696ee5fa7504"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
