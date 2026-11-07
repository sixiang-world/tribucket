class Fd < Formula
  desc "A simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  version "10.5.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.2/fd-v10.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "81bf98a16d3d7230e4a9123fcede243d71ea31a577113476ed43f1cdf4773162"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.2/fd-v10.5.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4b144f38bd7352cd4c95020b58e8e575476e60edcdf1dc5e0733e3d01efba6dd"
    end
    on_intel do
      url "https://github.com/sharkdp/fd/releases/download/v10.5.2/fd-v10.5.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "985e24041e9ef6e9a38e9e088743405dde23d7220aa96740f091862167d9ff28"
    end
  end

  def install
    bin.install Dir["fd*"].first => "fd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fd --version 2>&1", 1)
  end
end
