class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.1/deno-aarch64-apple-darwin.zip"
      sha256 "ee3473502118eab301eca93aa6b31d6b0b6c1602d0f59e4cb89d4a262b12f6e7"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.1/deno-x86_64-apple-darwin.zip"
      sha256 "89cbc8c974247772d9200724741b4e692ef49fe470b2ff555da905817c3daa11"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.1/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "0a60d079fa79635a59803074dbbfe86ccc35746dc2c4f8d73f2e50338b3283a9"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.1/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "710c54d63477d1100844ef4818f19507ce0dbf40510903b1d883f19e394446a2"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
