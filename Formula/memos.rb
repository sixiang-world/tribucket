class Memos < Formula
  desc "Open-source, self-hosted note-taking tool built for quick capture"
  homepage "https://github.com/usememos/memos"
  version "0.29.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.29.0/memos_0.29.0_darwin_arm64.tar.gz"
      sha256 "a97b6fb39b1ff5086aa648937bdc3699edff7e2a13eb96f5ed32a3943eb5d059"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.29.0/memos_0.29.0_darwin_amd64.tar.gz"
      sha256 "81cc802208ee9bed0c87e89863c13262ed75e9f08f4f5e67daf0eba0948cc4c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/usememos/memos/releases/download/v0.29.0/memos_0.29.0_linux_arm64.tar.gz"
      sha256 "ed8379f95250ecff330332d403182120e7498032006e1e73d91cf0f1831087be"
    end
    on_intel do
      url "https://github.com/usememos/memos/releases/download/v0.29.0/memos_0.29.0_linux_amd64.tar.gz"
      sha256 "e6e036b5328b2f2240164cecd86cf8b039c0e831a917a9149abb0810d4848e1b"
    end
  end

  def install
    bin.install Dir["memos*"].first => "memos"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memos --version 2>&1", 1)
  end
end
