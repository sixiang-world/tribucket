class Listmonk < Formula
  desc "High performance, self-hosted newsletter and mailing list manager"
  homepage "https://github.com/knadh/listmonk"
  version "7.0.0-beta.1"
  license "AGPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.1/listmonk_7.0.0-beta.1_darwin_arm64.tar.gz"
      sha256 "af3d2f12daa0893c5864b0bb1c95541319b026b502be552e949f0af03a9fff2d"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.1/listmonk_7.0.0-beta.1_darwin_amd64.tar.gz"
      sha256 "16655c302d6ce8e69ef71c64d6d8d688206a38a748bd37b8286cdb355ec72ec5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.1/listmonk_7.0.0-beta.1_linux_arm64.tar.gz"
      sha256 "c2b1ce59e76d5e225211ee7f87e28d3358b0601b60d52ebafc1dd33f2fbef827"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.1/listmonk_7.0.0-beta.1_linux_amd64.tar.gz"
      sha256 "78e7795fbe75a8114ba161df62c19851ce6681d750681160f6da65a631a66c4b"
    end
  end

  def install
    bin.install Dir["listmonk*"].first => "listmonk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/listmonk --version 2>&1", 1)
  end
end
