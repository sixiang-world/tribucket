class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta2/axonhub_1.0.0-beta2_darwin_arm64.zip"
      sha256 "d6dc984b52da14de34efa432129f500bda8967ef541d6fae9f0339b154c45691"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta2/axonhub_1.0.0-beta2_darwin_amd64.zip"
      sha256 "662c5b4cb98d370efbd3a5004acb8c960bf1dcf5e574aa9727ca2a11ef26471b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta2/axonhub_1.0.0-beta2_linux_arm64.zip"
      sha256 "8e7b0db9f2f8ffdef9a15948b5553f584b0b0c68669d01a1136a73243cbf108f"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta2/axonhub_1.0.0-beta2_linux_amd64.zip"
      sha256 "553771e96aab1c6e1ec5d332ed44bb47007902af7638984f28edd3a21c8e77cf"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
