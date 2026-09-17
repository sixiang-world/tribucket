class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.7/deno-aarch64-apple-darwin.zip"
      sha256 "5cd46d6268f6f78f5d88bdc7159d20bd44cdaa4b3303474839f87ec6fe7ae25c"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.7/deno-x86_64-apple-darwin.zip"
      sha256 "95daaff11c116a52ad54785e7914c8e9c9cdcaba793c5ed929c74ca2d8e6259a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.7/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "c832298b1ad4422481334855f6003e0f54145762c5a134f20a489511d2f65bbf"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.7/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "c6527f24f4b16031d3ae4fa9f658d5f11534c8d84ce7dc8502420280919c3490"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
