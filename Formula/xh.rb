class Xh < Formula
  desc "Friendly and fast HTTP requests tool (HTTPie alternative)"
  homepage "https://github.com/ducaale/xh"
  version "0.26.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ducaale/xh/releases/download/v0.26.2/xh-v0.26.2-aarch64-apple-darwin.tar.gz"
      sha256 "cc5739d061a8469d0011ca0ab92d4a5cd726cc56f0ef30108953b119f54d0719"
    end
    on_intel do
      url "https://github.com/ducaale/xh/releases/download/v0.26.2/xh-v0.26.2-x86_64-apple-darwin.tar.gz"
      sha256 "1f19ae1a2f411c58bd6943c638472cd5c4179ed019fe4f786e524b27da4c14a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ducaale/xh/releases/download/v0.26.2/xh-v0.26.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3a44900a8ac53f614aa0cd1d2e54ecf4e93584384c1ad091aa18d7992686d7eb"
    end
    on_intel do
      url "https://github.com/ducaale/xh/releases/download/v0.26.2/xh-v0.26.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8c53b6a23435754f9e2ea8ab8c0d0296a1921404b88132cf9b364ff6e8c22a6e"
    end
  end

  def install
    bin.install Dir["xh*"].first => "xh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xh --version 2>&1", 1)
  end
end
