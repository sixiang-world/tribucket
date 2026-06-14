class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "0.29.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.29.1/memos_0.29.1_darwin_arm64.tar.gz"
      sha256 "aa5a37f12dc388bb1b638925c8397e68ce94ae7e01a8ca884154f457a90d4e66"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.29.1/memos_0.29.1_darwin_amd64.tar.gz"
      sha256 "fa23f99259bceaab679a953a6e9563aab39d770ed827f4db9f0b9a424a4e241a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.29.1/memos_0.29.1_linux_arm64.tar.gz"
      sha256 "d38af7c63998b67b680983daa681fe2efd5e52a4b50f019d9913e3a109e0b6e4"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.29.1/memos_0.29.1_linux_amd64.tar.gz"
      sha256 "c31c241d1fd541d0dc64d9bf5bc30fc64dc666ebe9f33bbf96706f6bb3d9a78c"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
