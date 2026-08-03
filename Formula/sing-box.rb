class SingBox < Formula
  desc "The universal proxy platform"
  homepage "https://github.com/SagerNet/sing-box"
  version "1.13.16"
  license "GPL-3.0"

  on_macos do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.16/sing-box-1.13.16-darwin-arm64.tar.gz"
      sha256 "32fa21fd75ad62d86a2dcb7e0be77359c35e12798cdbb6a0e30654ef487d90d6"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.16/sing-box-1.13.16-darwin-amd64.tar.gz"
      sha256 "2bfad58d034e280c773e194be03649555e5a7040c48b559dd0898ad293fe793d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.16/sing-box-1.13.16-linux-arm64.tar.gz"
      sha256 "d587fb00bdc3c044227f35d15d154f271bc75108475091eda2542e4b82bb2949"
    end
    on_intel do
      url "https://github.com/SagerNet/sing-box/releases/download/v1.13.16/sing-box-1.13.16-linux-amd64.tar.gz"
      sha256 "e37c312859dfa84cba148f41072ff6369f08361ae91d622dc1fd3aab49611a8d"
    end
  end

  def install
    bin.install Dir["sing-box*"].first => "sing-box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sing-box --version 2>&1", 1)
  end
end
