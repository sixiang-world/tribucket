class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta1/axonhub_1.0.0-beta1_darwin_arm64.zip"
      sha256 "b3971200de166706e84effa05c7b939e1219014d4e97ca7c56eefe2430af76c8"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta1/axonhub_1.0.0-beta1_darwin_amd64.zip"
      sha256 "b458c8d254696424c5818feba03499ccdec3345602f87bfeb3f9ff0b6abf11b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta1/axonhub_1.0.0-beta1_linux_arm64.zip"
      sha256 "ea62b0139c96324a1a35f443a0f3c35e8c54e8eaf8d0ad9b2dbfab7a8784e95e"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta1/axonhub_1.0.0-beta1_linux_amd64.zip"
      sha256 "bd94922e91e5c5aa0078d107d6aa4f8c2a75ac4d12c96d3c46c46bd9211d365a"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
