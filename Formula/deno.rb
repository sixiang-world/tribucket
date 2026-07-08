class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.2/deno-aarch64-apple-darwin.zip"
      sha256 "687ae485168ba73a4f1ee3a954eb4f077eca82f2fefd236a6a83a3889287876c"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.2/deno-x86_64-apple-darwin.zip"
      sha256 "c953379e5a85a0a30e99aa51b807633e380e809a1181f53e4904d5fa73785bff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.2/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "310b8f48e59964ff18890d35e64f64fb90e8b1cc5d9ebff8c818327d5afb16d2"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.2/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "934d1bd5cb09eaed7f2e4a4fc58208d04a3c5c0fcde9f319d93d735265c67a4a"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
