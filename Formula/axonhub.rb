class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta8/axonhub_1.0.0-beta8_darwin_arm64.zip"
      sha256 "4c2162d1309095cc2218b800203f9b75f98f8252c12c8744d1d948aec84e81d4"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta8/axonhub_1.0.0-beta8_darwin_amd64.zip"
      sha256 "912d496e8ee2931d7c577137853a4fd5de32d17841aef48fa54aa2fb9a5c1d5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta8/axonhub_1.0.0-beta8_linux_arm64.zip"
      sha256 "611afa9c7cac16aa93d7997cb64204fd3fbc30864a9ecce9fc8fc5249301605b"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta8/axonhub_1.0.0-beta8_linux_amd64.zip"
      sha256 "fe9fdf04f4b00cd341aad7874f28f3cdfaa8a6bb415c5ffe9095dfdde8cb10af"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
