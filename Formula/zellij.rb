class Zellij < Formula
  desc "Terminal multiplexer with batteries included"
  homepage "https://github.com/zellij-org/zellij"
  version "0.44.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.44.3/zellij-aarch64-apple-darwin.tar.gz"
      sha256 "b6acf83a7739cf5f0f4e9bd47709642d4d98acbbf8c34d4a12c6e706f531da61"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.44.3/zellij-x86_64-apple-darwin.tar.gz"
      sha256 "59f803faa32cd4e5f316f0dc2d3b7a5530a72553e38ad939286471848a418eeb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/zellij-org/zellij/releases/download/v0.44.3/zellij-aarch64-unknown-linux-musl.tar.gz"
      sha256 "15e6534d42644d66973d136c590c49739dcfd6a1a2a0d3d917973f16c81b45fb"
    end
    on_intel do
      url "https://github.com/zellij-org/zellij/releases/download/v0.44.3/zellij-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0f7c346788627f506c0a28296517768633cff24fc822a739f8264b640ecad751"
    end
  end

  def install
    bin.install Dir["zellij*"].first => "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version 2>&1", 1)
  end
end
