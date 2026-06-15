class Tribucket < Formula
  desc "Lightweight portable package manager — install, track, check, update CLI tools"
  homepage "https://github.com/sixiang-world/tribucket"
  version "3.6.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.7/tribucket-darwin-arm64"
      sha256 "1a5daa785b7d1302d7b7aa0b741c8947d7bd6d5316f7b7497b2f3d2a1a328531"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.7/tribucket-linux-arm64"
      sha256 "abf6cfee5ba48161f94fb5fc10d814c49c1fead6d87c6c01689c9be4982ab2a7"
    end
    on_intel do
      url "https://github.com/sixiang-world/tribucket/releases/download/v3.6.7/tribucket-linux-amd64"
      sha256 "e424d476b62fa2c56ab159f92bcea4d7f496125df18f9f97a2026b236439e4dd"
    end
  end

  def install
    bin.install Dir["tribucket*"].first => "tribucket"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tribucket --version 2>&1", 1)
  end
end
