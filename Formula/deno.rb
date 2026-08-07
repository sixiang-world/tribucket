class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.5/deno-aarch64-apple-darwin.zip"
      sha256 "b796aadd131f6930560c1ee040cf0d6f53933fbb987464e9ff46bd7ea4830615"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.5/deno-x86_64-apple-darwin.zip"
      sha256 "c1b8b89a81e91b2a8b3f96def3195d08cfe3a105651da7908d53061f7140510d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.5/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "6b7cae3a8fc4385a59dea3146fcb8bad7fea4230e0ad36a8c692afacbc254be0"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.5/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "8b010a3b1a4a0188a67cdb8a7a27348b2a501af78aec7fc74f2ace167368d530"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
