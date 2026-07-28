class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta6/axonhub_1.0.0-beta6_darwin_arm64.zip"
      sha256 "91cea4ed67e4d7f52c29ebc45f35a89eb675832225df02f26380a573b5407d6d"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta6/axonhub_1.0.0-beta6_darwin_amd64.zip"
      sha256 "ee1323fa479f77d0f42c407ffd1f2795b3ab045ff1cbd88bf06d902910c29f68"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta6/axonhub_1.0.0-beta6_linux_arm64.zip"
      sha256 "a67281e092fa4a91dce00d9ad6071828bc0601cceceb6b90d779f94230f33c6c"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta6/axonhub_1.0.0-beta6_linux_amd64.zip"
      sha256 "7fd00fcd10042730c0fb5f9397aa5fde5a6e9ca1e8d73357e10d92c810ab8589"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
