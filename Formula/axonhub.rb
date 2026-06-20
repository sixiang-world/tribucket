class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-beta4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta4/axonhub_1.0.0-beta4_darwin_arm64.zip"
      sha256 "0d7c07cdd5f5af78f10a769af493e18c6365d8a56fd10d406117b3032b57745f"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta4/axonhub_1.0.0-beta4_darwin_amd64.zip"
      sha256 "8e6c0c5a50e343703f8cf708442b24a7a9b12bc2011cd2a491c65297b5a8d565"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta4/axonhub_1.0.0-beta4_linux_arm64.zip"
      sha256 "d93437c8f4ebd248aa0d84b4c017aa1b2cb590feee94ac71230046ecc6c21b57"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-beta4/axonhub_1.0.0-beta4_linux_amd64.zip"
      sha256 "676ef59b75e6a41059563bcbfd1285980f8f6a63e4e7c03900c76afab746b0ed"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
