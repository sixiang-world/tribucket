class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta12/axonhub_1.0.0-beta12_darwin_arm64.zip"
      sha256 "b0c4be0292135d03162288df2e5fe67ca3443da16ab156f8f6b3146fce0010d1"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta12/axonhub_1.0.0-beta12_darwin_amd64.zip"
      sha256 "b012821c6fe4f4058deb08ff7de7df76565c833e5c12b9a5601391a71087371b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta12/axonhub_1.0.0-beta12_linux_arm64.zip"
      sha256 "8b21b387cb785d0c45fd4d153e711c6a80892d414e5f342101feb688aea589a4"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta12/axonhub_1.0.0-beta12_linux_amd64.zip"
      sha256 "c8fc15e61fb95314b7106a43d9d14cce314fefbbb7848b042892db94ac834d4a"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
