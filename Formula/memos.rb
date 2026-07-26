class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "0.30.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.30.0/memos_0.30.0_darwin_arm64.tar.gz"
      sha256 "8156cb03cac46d599d06a12944b2cf9f224429599ec2a7066f6eb01ee96d7d24"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.30.0/memos_0.30.0_darwin_amd64.tar.gz"
      sha256 "f79d5be26cc65e053cd67c3beda4d762759f16f89e33e6c750b73cd3b7a10b0e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.30.0/memos_0.30.0_linux_arm64.tar.gz"
      sha256 "446a68ee969e092304b5f9b23d9669418613e25a1aa700e9767ade5cb30f2684"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.30.0/memos_0.30.0_linux_amd64.tar.gz"
      sha256 "099b4e1717eb500707d8ff27a8152d30524c4521918ba7c489eb1dda15c4e57d"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
