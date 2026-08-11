class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta7/axonhub_1.0.0-beta7_darwin_arm64.zip"
      sha256 "1c6d63a44de6f7598f9b4c0053f1dec3aa45f56cd0bbd32273817aa1351a0992"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta7/axonhub_1.0.0-beta7_darwin_amd64.zip"
      sha256 "351d2e0bd177269f15d0df7defa2887a664df778ec55adfe1c345345664b6eef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta7/axonhub_1.0.0-beta7_linux_arm64.zip"
      sha256 "96df6b1a1c3ea0dfc2b75fbe73f49ebe277ae9315661e613c3a8df7983d073d6"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta7/axonhub_1.0.0-beta7_linux_amd64.zip"
      sha256 "963c24f2dc1cef88f2724e28e0a73b07d98c11daef93df72848db401e07755b3"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
