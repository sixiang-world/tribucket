class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.74.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.0/fzf-0.74.0-darwin_arm64.tar.gz"
      sha256 "da60e8980e4239a0fc5f1fcfe873f243dfda93a6a13b696b00e1dc8584a77a87"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.0/fzf-0.74.0-darwin_amd64.tar.gz"
      sha256 "e2c470f058ac18615f54c0bebe0fd2956f2aa8e306a11621783a00aaa386eedd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.0/fzf-0.74.0-linux_arm64.tar.gz"
      sha256 "bd9e6165ebdb702215d42368cbb95b8dd70a4e77ee97925adac8c31660e30ef7"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.74.0/fzf-0.74.0-linux_amd64.tar.gz"
      sha256 "cf919f05b7581b4c744d764eaa704665d61dd6d3ca785f0df2351281dff60cda"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
