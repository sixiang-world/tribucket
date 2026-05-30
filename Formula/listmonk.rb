class Listmonk < Formula
  desc "High performance, self-hosted newsletter and mailing list manager"
  homepage "https://github.com/knadh/listmonk"
  version "6.1.0"
  license "AGPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v6.1.0/listmonk_6.1.0_darwin_arm64.tar.gz"
      sha256 "27a3bccfe9ac2bdd3c0dce50fa474496baac6855f18f5c34e0b8947629da2d30"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v6.1.0/listmonk_6.1.0_darwin_amd64.tar.gz"
      sha256 "00f40f5290136d787aa19da6c91472c68f25245dac0ce4ced411de9c155729f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v6.1.0/listmonk_6.1.0_linux_arm64.tar.gz"
      sha256 "5c3d604398f4015a263d1719e29eb61b14d8330372efb82ecc5fffc4df8712d1"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v6.1.0/listmonk_6.1.0_linux_amd64.tar.gz"
      sha256 "08f44f8f2c598cbef76c948dcb319df235296a07d49a49be3253d65c16d26ff0"
    end
  end

  def install
    bin.install Dir["listmonk*"].first => "listmonk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/listmonk --version 2>&1", 1)
  end
end
