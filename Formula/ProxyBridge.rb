class Proxybridge < Formula
  desc "Network proxy interception tool"
  homepage "https://github.com/InterceptSuite/ProxyBridge"
  version "3.2.0"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/InterceptSuite/ProxyBridge/releases/download/v3.2.0/ProxyBridge-Linux-v3.2.0.tar.gz"
      sha256 "a48db45b8fd6e83cc4c4a4b16da99b61812a383552ab24582c91cd8aa9928462"
    end
  end

  def install
    bin.install Dir["ProxyBridge*"].first => "ProxyBridge"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ProxyBridge --version 2>&1", 1)
  end
end
