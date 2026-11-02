class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "26.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.11.0/memos_26.11.0_darwin_arm64.tar.gz"
      sha256 "3bc92c7cd84aeefc71d601404b2a986309acb779309b8a5aaa34d3249609ffb5"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.11.0/memos_26.11.0_darwin_amd64.tar.gz"
      sha256 "020353bb3b51a20278400c333b9515a46a7686f3ebe24849c653e4b284e3bcd1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.11.0/memos_26.11.0_linux_arm64.tar.gz"
      sha256 "1575ed41ce1f668a2e70b50f73c95d2f1b04605db83d4529b8914358b394145e"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.11.0/memos_26.11.0_linux_amd64.tar.gz"
      sha256 "38b81c2bd1859555f4f7f277756541fd1ca332c94bbbee443626ace42d7b4061"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
