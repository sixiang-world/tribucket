class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.4/deno-aarch64-apple-darwin.zip"
      sha256 "6d17647fdbf9c587a581dba205054c4ccf732dae0a196cc1e9b44c07589db412"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.4/deno-x86_64-apple-darwin.zip"
      sha256 "f757df6d3991e37601c69fad56c22b37c4ea77b5dcfad3636a642c2ba4c9b19f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.4/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "111da5c05c240cfdc4340f234a0e3539d39dbcb6755221f19dcd60bacc8be5aa"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.4/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "c24f955d9fbfe0ea5ae2b501c8e71ae76e31e4c9782390a54a284b3364fda725"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
