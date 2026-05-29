class Fd < Formula
  desc "A simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  version "10.4.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.4.2/fd-v10.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "623dc0afc81b92e4d4606b380d7bc91916ba7b97814263e554d50923a39e480a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.4.2/fd-v10.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6c51f7c5446b3338b1e401ff15dc194c590bb2fa64fd43ff3278300f073adec5"
    end
    on_intel do
      url "https://github.com/sharkdp/fd/releases/download/v10.4.2/fd-v10.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "def59805cd14b5651b68990855f426ad087f3b96881296d963910431ba3143c8"
    end
  end

  def install
    bin.install Dir["fd*"].first => "fd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fd --version 2>&1", 1)
  end
end
