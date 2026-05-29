class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.8.1/deno-aarch64-apple-darwin.zip"
      sha256 "8154e2de0ee8c1cae31fa88e078724aaef0295fab9fd2ad6f8520389cee908f6"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.8.1/deno-x86_64-apple-darwin.zip"
      sha256 "47473845e0522ba11dd279e3dd318e2d84ee200c56b8280594e0ae0b0f827460"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.8.1/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "67e9df91870fd0af700df924173e3009ea7ff6956e2c3c3bb86065d6070d0fd6"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.8.1/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "2d7bb6195226ac832e0bf7109a115f0af65ee69ac797a4bbde5b27a06cc242d9"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
