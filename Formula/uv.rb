class Uv < Formula
  desc "An extremely fast Python package installer and resolver"
  homepage "https://github.com/astral-sh/uv"
  version "0.13.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.3/uv-aarch64-apple-darwin.tar.gz"
      sha256 "bf1e4fb6f5f5079a2902ad3f3a9e2d337575b226a1378f2449d8404353650608"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.3/uv-x86_64-apple-darwin.tar.gz"
      sha256 "5c35634957db7ebd9c2e4cc6c66b8979fb2c26a6b0dbd1d214d6acbac4033a89"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/astral-sh/uv/releases/download/0.13.3/uv-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "611ff684f193a84d2fdad29c5f12505d02ece94984c7c982cdde950eba5c95b9"
    end
    on_intel do
      url "https://github.com/astral-sh/uv/releases/download/0.13.3/uv-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e4f169ec380f1793b898a6f1fcbacd22db25cf7ca0349a6e96ffb85b69998d04"
    end
  end

  def install
    bin.install Dir["uv*"].first => "uv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uv --version 2>&1", 1)
  end
end
