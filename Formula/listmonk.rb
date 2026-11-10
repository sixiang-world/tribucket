class Listmonk < Formula
  desc "High performance, self-hosted newsletter and mailing list manager"
  homepage "https://github.com/knadh/listmonk"
  version "7.0.0-beta.2"
  license "AGPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.2/listmonk_7.0.0-beta.2_darwin_arm64.tar.gz"
      sha256 "cc99b7cf9d7783611d049457003b18c86f05e241d7c004af0b1171084529a821"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.2/listmonk_7.0.0-beta.2_darwin_amd64.tar.gz"
      sha256 "ff8ece292c1fc993707462decede9389b561d1886fac8fddac7529475d37cf73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.2/listmonk_7.0.0-beta.2_linux_arm64.tar.gz"
      sha256 "962d5efa290304cf0227228728c76123b229306279d298d3d8647c92b6695234"
    end
    on_intel do
      url "https://github.com/knadh/listmonk/releases/download/v7.0.0-beta.2/listmonk_7.0.0-beta.2_linux_amd64.tar.gz"
      sha256 "7d075dee9ad3d1efbc6a59d9e2283070b80f7bcd55ea3ecbc2851bf3065a62c8"
    end
  end

  def install
    bin.install Dir["listmonk*"].first => "listmonk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/listmonk --version 2>&1", 1)
  end
end
