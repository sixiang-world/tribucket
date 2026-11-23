class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "26.11.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.11.2/memos_26.11.2_darwin_arm64.tar.gz"
      sha256 "365f495ecab51cc49f21e84ab706b0081393d4921b08d73e25219184c8b7783b"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.11.2/memos_26.11.2_darwin_amd64.tar.gz"
      sha256 "36ae3cd0d39410d10bb1d488ff43d638653eb6208790c0105dfcde6b6d1ccbb2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.11.2/memos_26.11.2_linux_arm64.tar.gz"
      sha256 "2bea69a133782ca4dea41f6606bb8850eb32e44db9d7f0aa3d8e8d88b02e07a4"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.11.2/memos_26.11.2_linux_amd64.tar.gz"
      sha256 "2ad926ccd237e516f61097316c44f856a0b667f3e0de9b388982f39900c2e7ab"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
