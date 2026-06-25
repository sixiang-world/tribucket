class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.0/deno-aarch64-apple-darwin.zip"
      sha256 "2d11cf0505d4600a4492de8d07456a7a5e7eedebf68bdcbcb9092f520fcde0f1"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.0/deno-x86_64-apple-darwin.zip"
      sha256 "04f71604d738ef2a3b0c08d00743b1a6580fd65d0dab604da2f57f30f4c74b55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.0/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "a0f266eb189af2f27db0c6dcf9eb2f68ba2e8bbff1442c969ace398463f8b2bf"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.0/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "96c9c73fc05ea57603bc28d8071d41e861bd40bcf2a9f849dd5969ed1a2c8498"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
