class CcConnect < Formula
  desc "Claude Code connectivity utility"
  homepage "https://github.com/chenhg5/cc-connect"
  version "1.5.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.2/cc-connect-v1.5.2-darwin-arm64.tar.gz"
      sha256 "b27e0255032f5db7333043e0a34cdf071e5a7aa0b071c880f9c2f731b510e3ff"
    end
    on_intel do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.2/cc-connect-v1.5.2-darwin-amd64.tar.gz"
      sha256 "f8dcfd64942a21da10cb575e110708936678c2c57c4f17dd30cb42cb0be55f52"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.2/cc-connect-v1.5.2-linux-arm64.tar.gz"
      sha256 "e7c3470b2ca63cbb9556644c8689a3cb01f7b13d7beed071de0209bbe02abfb3"
    end
    on_intel do
      url "https://github.com/chenhg5/cc-connect/releases/download/v1.5.2/cc-connect-v1.5.2-linux-amd64.tar.gz"
      sha256 "ffa7ddbddca2ca759bd72f5ba2e3ed30cb1670776a7d4eb37125017590e96277"
    end
  end

  def install
    bin.install Dir["cc-connect*"].first => "cc-connect"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-connect --version 2>&1", 1)
  end
end
