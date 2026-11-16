class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "26.11.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.11.1/memos_26.11.1_darwin_arm64.tar.gz"
      sha256 "86d0e52b77a9361836b3100b2bf4f10c7ad5a8b9452b453395b4ccbbc1133c8a"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.11.1/memos_26.11.1_darwin_amd64.tar.gz"
      sha256 "f80c47d27f0e649d5bd5c649467a6c97f7596766e0386f6f5b38afdcb1f7c098"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.11.1/memos_26.11.1_linux_arm64.tar.gz"
      sha256 "4d68682534109888fca0f1d03aa73f5bd11942d419e5adb3bfb88fbbb284b8ae"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.11.1/memos_26.11.1_linux_amd64.tar.gz"
      sha256 "874b80ba4b3555f5520310c45fab6c2bee593c7b97ce03ebc4503010705f87ff"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
