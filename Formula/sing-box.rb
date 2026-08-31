class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.14.0"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.0/sing-box-1.14.0-darwin-arm64.tar.gz"
      sha256 "a150c94012ff768b7261939cd236b9c8554127f45137230295d23a5660225cc9"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.0/sing-box-1.14.0-darwin-amd64.tar.gz"
      sha256 "6cf26fc3501f3117cf781e9405cf5338f60add6da5affae39421af6800ebbcb4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.0/sing-box-1.14.0-linux-arm64.tar.gz"
      sha256 "04d9b40bc98dc55b6f509ce3292145c65478f65866bea64826ebb2f382385088"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.14.0/sing-box-1.14.0-linux-amd64.tar.gz"
      sha256 "2375de6999f4f56ab46b4fc5ddf26a6aba1d3e61a0f4e7ddec2f4690457d5f63"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
