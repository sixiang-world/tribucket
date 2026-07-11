class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta5/axonhub_1.0.0-beta5_darwin_arm64.zip"
      sha256 "583e0abfe11b689f274ec5bd6f6fd657f40dcfba6a73714a9a64a7df9ef3b51f"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta5/axonhub_1.0.0-beta5_darwin_amd64.zip"
      sha256 "59486591191d0f190fee1d4c7933911012a57014a147743490e5aa7ce1cf9ac7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta5/axonhub_1.0.0-beta5_linux_arm64.zip"
      sha256 "789f1ed8500604c29faed9f2def06d1022b696da849d35644191a6d96d46c1c7"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta5/axonhub_1.0.0-beta5_linux_amd64.zip"
      sha256 "fa8f764c559965d84c92908a2fc973effce5c569a56843e4771c8fc9c6496bfb"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
