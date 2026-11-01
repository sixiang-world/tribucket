class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "26.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.10.0/memos_26.10.0_darwin_arm64.tar.gz"
      sha256 "8db2970893f5f0adc4e0143de6b7c27453d8586766a7627219cf1d9e3563e12c"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.10.0/memos_26.10.0_darwin_amd64.tar.gz"
      sha256 "eb79a53dbd9663eaeaa70b707f5d9649c5cd325da971575f52f999c31818c364"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/26.10.0/memos_26.10.0_linux_arm64.tar.gz"
      sha256 "b4219fd58993d01a1340913487121624fb076099f3686972437c7a40a02225a7"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/26.10.0/memos_26.10.0_linux_amd64.tar.gz"
      sha256 "873e639c6a9e9bac47af57d628477fa87b7e965fadf0354c7d1a4e5280681de7"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
