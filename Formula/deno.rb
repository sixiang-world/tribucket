class Deno < Formula
  desc "Modern runtime for JavaScript and TypeScript"
  homepage "https://github.com/denoland/deno"
  version "2.8.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.8.2/deno-aarch64-apple-darwin.zip"
      sha256 "02e5eb795c9f763772dfd081429cead9029e0a4a6aaff6d4e5f3ed6d2e94d361"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.8.2/deno-x86_64-apple-darwin.zip"
      sha256 "77cf27f835f1921e49434449675c57432c6314d54edc725e2474cc825546e206"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/denoland/deno/releases/download/v2.8.2/deno-aarch64-unknown-linux-gnu.zip"
      sha256 "48647189aee6454ed9b9852fa700a77f92b39465c04c625901d165bc8e937afc"
    end
    on_intel do
      url "https://github.com/denoland/deno/releases/download/v2.8.2/deno-x86_64-unknown-linux-gnu.zip"
      sha256 "184da7a5267ab649bc08821b3bc3ce6805d8e6985fb82707cb8d5e9fd6535362"
    end
  end

  def install
    bin.install Dir["deno*"].first => "deno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deno --version 2>&1", 1)
  end
end
