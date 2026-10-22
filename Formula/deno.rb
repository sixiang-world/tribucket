class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.9.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.8/deno-aarch64-apple-darwin.zip"
      sha256 "9f0bf660393da2eaff044cdc7444cb08c73f235849b61d224d825a194ce7c98e"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.8/deno-x86_64-apple-darwin.zip"
      sha256 "4b2f5edd2639b7470f034238b321d7002d8dfb4726d8558f52c17afac370eb2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.9.8/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "d49596c20b9788cf8f5d8ddf644103d4bde56ed239753f0bdb92ba9361d51905"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.9.8/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "e890975bc2549807bbcc0b584ffafda72cc7c93349dd99c80483dd784f6c4609"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
