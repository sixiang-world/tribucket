class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta3/axonhub_1.0.0-beta3_darwin_arm64.zip"
      sha256 "82bbbe1ea23e5d90785ef0c3ae46f0519ebb4c33794ec5f3ae0ce33b34eabdec"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta3/axonhub_1.0.0-beta3_darwin_amd64.zip"
      sha256 "6af9f17ea0f35d49ce4ead966ac59f37e7bbd5ef061e27afe135784c2d03ce73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta3/axonhub_1.0.0-beta3_linux_arm64.zip"
      sha256 "c8d496433c3c5fbb32949899c35cc6d642c1e1ed3ff8488b34239a1961b29b1b"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta3/axonhub_1.0.0-beta3_linux_amd64.zip"
      sha256 "6a71c7afa6fae3c6dba7dbea09c706056cc1abdf18b38881a71a5ffb310e4836"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
