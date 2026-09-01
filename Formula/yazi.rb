class Yazi < Formula
  desc "Blazing fast terminal file manager"
  homepage "https://github.com/sxyazi/yazi"
  version "26.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sxyazi/yazi/releases/download/v26.9.1/yazi-aarch64-apple-darwin.zip"
      sha256 "3921182a21cceb0a505e5dac578e1487d48104caa5f114e9f8adf40b5a7289a9"
    end
    on_intel do
      url "https://github.com/sxyazi/yazi/releases/download/v26.9.1/yazi-x86_64-apple-darwin.zip"
      sha256 "36e09036fcc446488d876d139a5e303f2443b82cfb6ac7dfcb43892d6fe6fa20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sxyazi/yazi/releases/download/v26.9.1/yazi-aarch64-unknown-linux-gnu.zip"
      sha256 "02807f08d6b589b65b7516a4e259d83f5995d7a23bb12b3a155141385b370b3a"
    end
    on_intel do
      url "https://github.com/sxyazi/yazi/releases/download/v26.9.1/yazi-x86_64-unknown-linux-gnu.zip"
      sha256 "a02fe91d3304294048c681f010f1100856872a4e98ecf6927328e888d40a6ad2"
    end
  end

  def install
    bin.install Dir["yazi*"].first => "yazi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yazi --version 2>&1", 1)
  end
end
