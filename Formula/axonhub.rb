class Axonhub < Formula
  desc "Open-source AI Gateway — call 100+ LLMs with failover and load balancing"
  homepage "https://github.com/looplj/axonhub"
  version "1.0.0-rc2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc2/axonhub_1.0.0-rc2_darwin_arm64.zip"
      sha256 "dad69fc7f3ea63bdf84ce7739c6db6e797c191621539d171e371b60d0f3613a2"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc2/axonhub_1.0.0-rc2_darwin_amd64.zip"
      sha256 "f84bca1168f5abbaa2944daa0a82633b3e9c695cf5f14bbc634b50e60b771676"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc2/axonhub_1.0.0-rc2_linux_arm64.zip"
      sha256 "6f9edbef215f7165034226e4c9481b129d43f752ab9a5fdccb3ea00fadfc9392"
    end
    on_intel do
      url "https://github.com/looplj/axonhub/releases/download/v1.0.0-rc2/axonhub_1.0.0-rc2_linux_amd64.zip"
      sha256 "42fdc484185be4b10deeaaa3d10be7322c3f6757a680dc0faaebb46f79832936"
    end
  end

  def install
    bin.install Dir["axonhub*"].first => "axonhub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axonhub --version 2>&1", 1)
  end
end
