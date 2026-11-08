class Fzf < Formula
  desc "Command-line fuzzy finder"
  homepage "https://github.com/junegunn/fzf"
  version "0.75.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.75.0/fzf-0.75.0-darwin_arm64.tar.gz"
      sha256 "1e76698eb481436e42119bea6aa6e2bd9552ff090789d769c286e3c3a4e0ded6"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.75.0/fzf-0.75.0-darwin_amd64.tar.gz"
      sha256 "8fa67fa874468b8e73ecad2df82cc110026f45d10605128aaac6b191262d2844"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/junegunn/fzf/releases/download/v0.75.0/fzf-0.75.0-linux_arm64.tar.gz"
      sha256 "bd0717badb6a5620387e014bb94209aac4d9eab6ab77b5348eabb0833aeb4d59"
    end
    on_intel do
      url "https://github.com/junegunn/fzf/releases/download/v0.75.0/fzf-0.75.0-linux_amd64.tar.gz"
      sha256 "0d6640f83582d991cf429754baad64b07e3a4e439a6019670f4b91da1314141c"
    end
  end

  def install
    bin.install Dir["fzf*"].first => "fzf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf --version 2>&1", 1)
  end
end
