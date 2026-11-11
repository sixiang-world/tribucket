class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-rc.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.3/axonhub_1.0.0-rc.3_darwin_arm64.zip"
      sha256 "96bc0c7f6822aa3d51c649494e6f40cd19fb7ac3a27371c46d1e1483194426f4"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.3/axonhub_1.0.0-rc.3_darwin_amd64.zip"
      sha256 "94d06ec3c617bc4ebce6367423bda56a824c98c46b943d64d03f2516748955ba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.3/axonhub_1.0.0-rc.3_linux_arm64.zip"
      sha256 "955ec9792c5c697461da5ce7cb9baeeccdd808dc34f7b2a7650116da2af14df3"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.3/axonhub_1.0.0-rc.3_linux_amd64.zip"
      sha256 "33ceb453c9576bf3caf657047d4b66e32175a8a7f2332b4c45089ff15babd17e"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
