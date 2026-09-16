class Listmonk < Formula
  desc "High performance, self-hosted newsletter and mailing list manager"
  homepage "https://github.com/knadh/listmonk"
  version "6.2.0"
  license "AGPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v6.2.0/listmonk_6.2.0_darwin_arm64.tar.gz"
      sha256 "692ebcbec722319c1d0c7705ea0d7191e1be38e8ec40b417f2f9210fbe4c601b"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v6.2.0/listmonk_6.2.0_darwin_amd64.tar.gz"
      sha256 "e74d487d0a0b231b58eb9cccd55a62bf31047f3838ddfb8c4ca0872ec6a675d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v6.2.0/listmonk_6.2.0_linux_arm64.tar.gz"
      sha256 "7e8f77dcdd2caf83b4b7774ecc44de7cea6852596084a4a2b5aab15464a45549"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v6.2.0/listmonk_6.2.0_linux_amd64.tar.gz"
      sha256 "ce78c89d8aac0df3ffe0e110b008e7bb5dae13e6ad0c57b43aa7094971e8698e"
    end
  end

  def install
    bin.install Dir["listmonk*"].first => "listmonk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/listmonk --version 2>&1", 1)
  end
end
