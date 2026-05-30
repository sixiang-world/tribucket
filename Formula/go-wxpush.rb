class GoWxpush < Formula
  desc "WeChat push notification utility"
  homepage "https://github.com/hezhizheng/go-wxpush"
  version "1.0.4"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/hezhizheng/go-wxpush/releases/download/v1.0.4/go-wxpush_darwin_amd64"
      sha256 "aa8bacb985f02776f23b8bf96757c2b1232243c1afe74a84c65b7ba02f620e6a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hezhizheng/go-wxpush/releases/download/v1.0.4/go-wxpush_linux_arm64"
      sha256 "3abc209e87c502b6640873ab9f1ac6147caeecd7737b325c2979aad2fb33ae45"
    end
    on_intel do
      url "https://github.com/hezhizheng/go-wxpush/releases/download/v1.0.4/go-wxpush_linux_amd64"
      sha256 "dcfc47186301035829a9b08f1079f97792c5685837f40c08b5cf5173e9091f75"
    end
  end

  def install
    bin.install Dir["go-wxpush*"].first => "go-wxpush"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-wxpush --version 2>&1", 1)
  end
end
