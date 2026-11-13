class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-rc.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.4/axonhub_1.0.0-rc.4_darwin_arm64.zip"
      sha256 "2a1dd8040507cad4aa4d69bf8d165a4537c6115d9e00218296cfada799314385"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.4/axonhub_1.0.0-rc.4_darwin_amd64.zip"
      sha256 "86d87a48590fb926a6475271b98d2eae33d2da2e9ea7fed60aecc207f65e5af2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.4/axonhub_1.0.0-rc.4_linux_arm64.zip"
      sha256 "a14e1d5f5365749ac1c7f18fddde70bd6119a26ac7dc3f3d5dc2a57295131379"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc.4/axonhub_1.0.0-rc.4_linux_amd64.zip"
      sha256 "a60006e0dab315720875d3ebf39138dee63bbdaa64e44e040135e7c9df97cf5c"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
