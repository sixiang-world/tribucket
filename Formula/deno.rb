class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.3/deno-aarch64-apple-darwin.zip"
      sha256 "1b2972f7ceb6df28d9600eab18d423bebb9aa18db02f01d7eb37a5b501482203"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.3/deno-x86_64-apple-darwin.zip"
      sha256 "cff2bce236fde0952aac62a5699464c46901b4eb1e61d0caffbb33d556e098c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.3/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "753937db98a4b56cbbbd26e8f00eb4b789191a229afec93f74bcfa4e79bc2c8b"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.3/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "8101865641cbede56f08ad19c0a67a87df84bce127fee0d3e3e1f7467717ffa6"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
