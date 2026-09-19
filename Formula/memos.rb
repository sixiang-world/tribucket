class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "0.31.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.31.0/memos_0.31.0_darwin_arm64.tar.gz"
      sha256 "96b401609154503d4db372ea60f0a9b9c0caf80b698b548a890efb1649911839"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.31.0/memos_0.31.0_darwin_amd64.tar.gz"
      sha256 "0415916c0a2f8e063450ebf291e88fd772a258a021966df021c88008e95f7d3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.31.0/memos_0.31.0_linux_arm64.tar.gz"
      sha256 "97489ad1dd669cf63cda411f670ad0c5669148562a27364cb9e54e7ee79e9d4b"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.31.0/memos_0.31.0_linux_amd64.tar.gz"
      sha256 "d99bf9de5e947cd41f7f1ae59e1e97d9af933d1bcc2d1316b3ab1ffe0a69e5c0"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
